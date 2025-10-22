#!/usr/bin/env python3
"""
Basic AWS resource report to identify candidates for cost optimization.
This script lists EC2 instances and unattached EBS volumes.
"""

import boto3

def report_ec2_instances(region='eu-west-1'):
    ec2 = boto3.client('ec2', region_name=region)
    resp = ec2.describe_instances()
    instances = []
    for r in resp['Reservations']:
        for i in r['Instances']:
            instances.append({
                'InstanceId': i.get('InstanceId'),
                'State': i.get('State', {}).get('Name'),
                'InstanceType': i.get('InstanceType'),
                'Tags': i.get('Tags'),
                'PublicIp': i.get('PublicIpAddress')
            })
    return instances

def report_unattached_volumes(region='eu-west-1'):
    ec2 = boto3.client('ec2', region_name=region)
    vols = ec2.describe_volumes(Filters=[{'Name':'status', 'Values':['available']}])
    return vols['Volumes']

if __name__ == "__main__":
    print("EC2 instances:")
    for i in report_ec2_instances():
        print(i)
    print("\nUnattached EBS volumes:")
    for v in report_unattached_volumes():
        print(v['VolumeId'], v['Size'], "GiB")

