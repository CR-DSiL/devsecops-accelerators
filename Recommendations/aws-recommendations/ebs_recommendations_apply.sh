#!/bin/bash

function getVolumeId() {
    delimiter="volume/"
    s=$1$delimiter
    VOLUMEDETAILS=();
    while [[ $s ]];
    do
        VOLUMEDETAILS+=("${s%%"$delimiter"*}");
        s=${s#*"$delimiter"};
    done;

    VOLUMEID=${VOLUMEDETAILS[1]}
}

#VolumeArn
VOLUMEARN=$( jq -r '.volumeRecommendations[].volumeArn' < ebs.json )
#VOLUMEARN="arn:aws:ec2:us-east-1:876737291315:volume/vol-00e9c6f138981857d"
getVolumeId $VOLUMEARN
echo $VOLUMEID

#Recommended Options
VOLUMETYPETYPE=$( jq -r '.volumeRecommendations[].volumeRecommendationOptions[].configuration.volumeType' < ebs.json )
echo "Recommednded volumeType: ${VOLUMETYPE}"

aws ec2 modify-volume \
    --volume-type gp2 \
    --size 8 \
    --volume-id vol-00e9c6f138981857d

#aws ec2 modify-volume \
#    --volume-type gp2 \
#    --iops 3000 \
#    --size 8 \
#    --volume-id vol-00e9c6f138981857d