import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = os.getenv('INSTANCE_ID')
    ec2.stop_instances(InstanceIds=[instance_id])
    return f"Stopping instance: {instance_id}"
