#!/bin/bash

image_id=ami-034fffcc6a0063961
instance_type=t2.micro
vpc_id=vpc-0d177f4666b78d22f
key_name=user9
subnet_id=subnet-00be0f5b55838b5bf
shutdown_type=stop
tags="ResourceType=instance,Tags=[{Key=installation_id,Value=user9},{Key=Name,Value=user9-vm1}]"

start()
{
  private_ip_address="10.4.1.92"
  public_ip=associate-public-ip-address

  aws ec2 run-instances \
    --image-id "$image_id" \
    --instance-type "$instance_type" \
    --key-name "$key_name" \
    --subnet-id "$subnet_id" \
    --instance-initiated-shutdown-behavior "$shutdown_type" \
    --private-ip-address "$private_ip_address" \
    --tag-specifications "$tags" \
    --${public_ip}

  #  [--security-groups] 
  #  [--block-device-mappings <value>]                               
  #  [--placement <value>]                                           
  #  [--user-data <value>]

}

stop()
{
  ids=($(
    aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?KeyName==`'$key_name'`].InstanceId' \
    --output text
  ))
  aws ec2 terminate-instances --instance-ids "${ids[@]}"
}

if [ "$1" = start ]; then
  start
elif [ "$1" = stop ]; then
  stop
else
  cat <<EOF
Usage:

  $0 start|stop
EOF
fi


