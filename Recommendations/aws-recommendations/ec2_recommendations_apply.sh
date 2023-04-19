#!/bin/bash

function getInstanceId() {
    delimiter="instance/"
    s=$1$delimiter
    INSTANCEDETAILS=();
    while [[ $s ]];
    do
        INSTANCEDETAILS+=("${s%%"$delimiter"*}");
        s=${s#*"$delimiter"};
    done;

    INSATNCEID=${INSTANCEDETAILS[1]}
}

INSTANCEARN=$( jq -r '.instanceRecommendations[].instanceArn' < ec2.json )
#INSTANCEARN="arn:aws:ec2:us-east-1:876737291315:instance/i-09bda3910e4a06b7d"
getInstanceId $INSTANCEARN
echo $INSATNCEID

INSTANCETYPE=$( jq -r '.instanceRecommendations[].recommendationOptions[].instanceType' < ec2.json )
echo "Recommednded instanceType: ${INSTANCETYPE}"

aws ec2 stop-instances --instance-ids $INSATNCEID

sleep 10

aws ec2 modify-instance-attribute --instance-id $INSATNCEID --instance-type "{\"Value\": \"t3.micro\"}"

aws ec2 start-instances --instance-ids $INSATNCEID