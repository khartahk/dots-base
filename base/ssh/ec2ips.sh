#!/usr/bin/env bash

# Set $HOST from 1st argument or eb environment
HOST=""
if [ -n "$1" ]; then
  export HOST=$1;
elif [ -n "$AWS_EB_ENVIRONMENT" ]; then
  export HOST=$AWS_EB_ENVIRONMENT;
fi

# Set $PROFILE from $HOST or 2nd arguments
PROFILE="$(echo $HOST | cut -d'-' -f 1)"
if [ -n "$2" ]; then
  export PROFILE_FLAG="--profile $2"
  export PROFILE="$2";
fi

export IPADDRESSTYPE="PrivateIpAddress";
if [[ "1" -eq "$3" ]]; then
  export IPADDRESSTYPE="PublicIpAddress";
fi

# Set $SRVNUM - server number when connecting to autoscaling group, defaults to 1st server if not set
SRVNUM="${4:-1}"

if [[ "$HOST" = *"bastion"* ]]; then
  printf %s $(aws ec2 describe-instances $PROFILE_FLAG --filters "Name=tag:Name,Values=$HOST" --query "Reservations[*].Instances[*].PublicIpAddress" --output text | sed "s/\s/\n/g" | sed "${SRVNUM}q;d")
else
  printf %s $(aws ec2 describe-instances $PROFILE_FLAG --filters "Name=tag:Name,Values=$HOST" --query "Reservations[*].Instances[*].$IPADDRESSTYPE" --output text | sed "s/\s/\n/g" | sed "${SRVNUM}q;d")
fi
