import boto3
import os

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instance_id = os.environ['INSTANCE_ID']
    
    ec2.start_instances(InstanceIds=[instance_id])
    print(f"Instance {instance_id} started.")
