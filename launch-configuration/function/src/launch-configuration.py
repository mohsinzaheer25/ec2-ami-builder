import json
import os

import boto3


def update_parameter_store(ssm_client, asg_name, ami_id):
    # Misc: Setup empty dictionary
    parameter_store_data = {}

    parameter_store_data = {
        "asg-name": asg_name,
        "ami-id": ami_id,
    }

    print(parameter_store_data)

    # Step 4: Update Parameter Store

    new_list_parameter = ssm_client.put_parameter(
        Name='ami-update-param',
        Value=json.dumps(parameter_store_data),
        Type='StringList',
        Overwrite=True,
    )
    print(
        f"StringList Parameter created with version {new_list_parameter['Version']}"
    )


def lambda_handler(event, context):
    eks_version = os.environ.get('eks_version')

    # Step 1. Check SNS Topic

    topic = event["Records"][0]["Sns"]["TopicArn"]
    ssm_client = boto3.client('ssm')

    if 'windows-ami-update' in topic:
        print("Windows AMI Updated. Getting latest AMI ID For Windows Full")

        # Step 2 : Get Latest AMI ID For Windows Full

        ssm_key = "/aws/service/ami-windows-latest/Windows_Server-2019-English-Full-EKS_Optimized-" + str(
            eks_version) + "/image_id"
        parameter = ssm_client.get_parameter(Name=ssm_key, WithDecryption=True)
        ami = parameter['Parameter']['Value']
        print(f"New AMI ID of Windows_Server-2019-English-Full-EKS_Optimized: {ami} from {ssm_key}")

        # Step 3: Get List of ASG Names for Windows

        windows_asg_names = os.environ.get('windows_asg_names')
        windows_all_asg = windows_asg_names.split(',')
        for windows_asg in windows_all_asg:
            update_parameter_store(ssm_client, windows_asg, ami)

    elif 'amazon-linux-2-ami-updates' in topic:
        print("Amazon Linux 2 AMI Updated. Getting latest AMI ID For Amazon Linux 2")

        # Step 2 : Get Latest AMI ID For Amazon Linux 2

        ssm_key = "/aws/service/eks/optimized-ami/" + str(
            eks_version) + "/amazon-linux-2/recommended/image_id"
        parameter = ssm_client.get_parameter(Name=ssm_key, WithDecryption=True)
        ami = parameter['Parameter']['Value']
        print(f"New AMI ID of Amazon Linux 2 : {ami} from {ssm_key}")

        # Step 3: Get List of ASG Names for Linux

        linux_asg_names = os.environ.get('linux_asg_names')
        linux_all_asg = linux_asg_names.split(',')
        for linux_asg in linux_all_asg:
            update_parameter_store(ssm_client, linux_asg, ami)

    else:
        print("SNS Topic ARN not matching to Windows or Linux. See Below")
        print(topic)

    return {
        'statusCode': 200,
    }
