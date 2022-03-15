import datetime
import time
import boto3
import os


def lambda_handler(event, context):
    # Create boto3 clients
    ec2 = boto3.client("ec2")
    ssm = boto3.client('ssm')
    asg = boto3.client("autoscaling")

    # Get values from Lambda environment variables.

    # launch_template_id = "lt-06b85cad88c434730"
    
    launch_template_id = os.environ["launch_template_id"]
    ssm_key = event['detail']['name']

    parameter = ssm.get_parameter(Name=ssm_key, WithDecryption=True)
    ami = parameter['Parameter']['Value']
    print(f"New AMI ID : {ami}")

    # update_current_launch_template_ami

    response = ec2.create_launch_template_version(
        LaunchTemplateId=launch_template_id,
        SourceVersion="$Latest",
        VersionDescription="Latest-AMI",
        LaunchTemplateData={
            "ImageId": ami
        }
    )
    print(f"New launch template created with AMI {ami}")

    # set_launch_template_default_version

    response = ec2.modify_launch_template(
        LaunchTemplateId=launch_template_id,
        DefaultVersion="$Latest"
    )
    print("Default launch template set to $Latest.")

    # update_asg_config-latest_ami

    # get object for the ASG we're going to update, filter by name of target ASG
    # targetASG = 'testy-asg'
    targetASG = os.environ['targetASG']
    response = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[targetASG])
    if not response['AutoScalingGroups']:
        return 'No such ASG'

        # get name of InstanceID in current ASG that we'll use to model new Launch Configuration after
    sourceInstanceId = response.get('AutoScalingGroups')[0]['Instances'][0]['InstanceId']

    # create LC using instance from target ASG as a template, only diff is the name of the new LC and new AMI
    timestamp = time.time()
    timestampstring = datetime.datetime.fromtimestamp(timestamp).strftime('%Y-%m-%d  %H-%M-%S')
    newlaunchconfigname = 'LC ' + ami + ' ' + timestampstring
    asg.create_launch_configuration(
        InstanceId=sourceInstanceId,
        LaunchConfigurationName=newlaunchconfigname,
        ImageId=ami)

    # update ASG to use new LC
    response = asg.update_auto_scaling_group(AutoScalingGroupName=targetASG,
                                             LaunchConfigurationName=newlaunchconfigname)

    print(
        f"'Updated ASG {targetASG} with new launch configuration {newlaunchconfigname} which includes AMI {ami}.")

    return {
        "status": 200
    }
