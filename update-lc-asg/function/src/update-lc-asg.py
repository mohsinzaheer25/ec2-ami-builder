import json
import os

import boto3


def lambda_handler(event, context):
    # Create boto3 clients
    ec2_client = boto3.client("ec2")
    ssm_client = boto3.client('ssm')
    asg_client = boto3.client("autoscaling")

    # Step 1: Get SSM Parameter Store Value

    ssm_key = event['detail']['name']

    parameter = ssm_client.get_parameter(Name=ssm_key, WithDecryption=True)
    parameter_store_data = parameter['Parameter']['Value']

    if parameter_store_data == "no-value":
        print("SSM has default no value so, we are not updating anything. Have a great day!!!")
    else:
        parameter_store_data = json.loads(parameter_store_data)  # Converting String into json object

        ami = parameter_store_data['ami-id']
        asg = parameter_store_data['asg-name']

        print(f"New AMI ID : {ami}")

        # Step 2: Get Launch Template ID

        asg_response = asg_client.describe_auto_scaling_groups(
            AutoScalingGroupNames=[
                asg,
            ],
        )
        launch_template_id = asg_response['AutoScalingGroups'][0]['LaunchTemplate']['LaunchTemplateId']

        # Step 3: Create New Launch Template Config Version

        response = ec2_client.create_launch_template_version(
            LaunchTemplateId=launch_template_id,
            SourceVersion="$Latest",
            VersionDescription="Latest-AMI",
            LaunchTemplateData={
                "ImageId": ami
            }
        )
        print(
            f"New launch template created for Launch Template ID: {launch_template_id} with AMI: {ami} for Autoscaling "
            f"group: {asg}")

        # Step 4: Set New Launch Template Config Version as Default

        response = ec2_client.modify_launch_template(
            LaunchTemplateId=launch_template_id,
            DefaultVersion="$Latest"
        )
        print("Default launch template set to Latest.")

        # Step 5: Rotate Nodes if its non prod.
        environment = os.environ.get('env')

        if environment == 'nonprod':
            instance_refresh_response = asg_client.start_instance_refresh(
                AutoScalingGroupName=asg,
                Strategy='Rolling',
                Preferences={
                    'MinHealthyPercentage': 100,
                    # Setting the minimum healthy percentage to 100 percent limits the rate of replacement to one
                    # instance at a time.
                    'InstanceWarmup': 300,
                }
            )

            print(
                f"Instance Refresh ID : {instance_refresh_response['InstanceRefreshId']} for Autoscaling group name: {asg}")
        else:
            print("Environment is not non prod so, skipping instance refresh.")

    return {
        "status": 200
    }
