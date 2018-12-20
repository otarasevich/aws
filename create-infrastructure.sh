#!/bin/bash

USER_NAME=user9
IMAGE_ID=ami-0b413adeb323658b1 #ami-034fffcc6a0063961
INSTANCE_TYPE=t2.micro
VPC_ID=vpc-0d177f4666b78d22f
KEY_NAME=user9
SUBNET_ID=subnet-00be0f5b55838b5bf
SHUTDOWN_TYPE=stop
TAGS="ResourceType=instance,Tags=[{Key=installation_id,Value=${USER_NAME}-1},{Key=Name,Value=NAME}]"

start_vm()
{
  local private_ip_address="$1"
  local public_ip="$2"
  local name="$3"
  local user_data="$4"
  local tags=$(echo $TAGS | sed s/NAME/$name/)

  aws ec2 run-instances \
    --image-id "$IMAGE_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --subnet-id "$SUBNET_ID" \
    --instance-initiated-shutdown-behavior "$SHUTDOWN_TYPE" \
    --private-ip-address "$private_ip_address" \
    --tag-specifications "$tags" \
    --user-data "$user_data" \
    --${public_ip} \
  | jq -r .Instances[0].InstanceId
}

get_dns_name()
 start()
 {
  start_log=$(
  start_vm 10.4.1.91 associate-public-ip-address ${USER_NAME}-vm1 file://${PWD}/scripts/initial-command.sh
   )
  }


#get_dns_name()
#{
#  local instance-"$1"
#
#  aws ec2 describe-instances --instance-ids ${instance} \
#  | jq -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName'
#}

#start()
#{
#  start_vm 10.4.1.91 associate-public-ip-address user9-vm1
#  for i in {2..3}; do
#    start_vm 10.4.1.$((90+i)) no-associate-public-ip-address user9-vm$1
#done
#}

start()
{
  start_log=$(
    start_vm 10.4.1.91 associate-public-ip-address ${USER_NAME}-vm1
  )

  instance_id=$(echo "${start_log}" | jq -r .Instances[0].InstanceId)

  for i in {2..3}; do
    start_vm 10.4.1.$((90+i)) no-associate-public-ip-address ${USER_NAME}-vm$i > /dev/null
  done

  dns_name=$(get_dns_name "$instance_id")
  echo $dns_name
}

stop()
{
  ids=($(
    aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?KeyName==`'$KEY_NAME'`].InstanceId' \
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
