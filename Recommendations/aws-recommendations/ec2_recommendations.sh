#!/bin/bash

cd /tmp/jenkins/workspace/AWS_Recommendations/aws_recommendations

BRANCH=${RANDOM}

whoami

git checkout -b "${BRANCH}"

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

###Get recommendations for ec2 instances###
#aws compute-optimizer get-ec2-instance-recommendations > ec2.json

#InstanceArn
INSTANCEARN=$( jq -r '.instanceRecommendations[].instanceArn' < ec2.json )
#INSTANCEARN="arn:aws:ec2:us-east-1:876737291315:instance/i-09bda3910e4a06b7d"
getInstanceId $INSTANCEARN
echo $INSATNCEID
#AccountID
ACCOUNTID=$( jq -r '.instanceRecommendations[].accountId' < ec2.json )
echo "accountId: ${ACCOUNTID}"
#Recommended Options
INSTANCETYPE=$( jq -r '.instanceRecommendations[].recommendationOptions[].instanceType' < ec2.json )
echo "Recommednded instanceType: ${INSTANCETYPE}"
#Recommended Options
PROJECTUTILIZATIONMETRICS=$( jq -r '.instanceRecommendations[].recommendationOptions[].projectedUtilizationMetrics' < ec2.json )
echo "projectUtilizationMetrics: ${PROJECTUTILIZATIONMETRICS}"
#Recommended Options
PLATFORMDIFFERENCES=$( jq -r '.instanceRecommendations[].recommendationOptions[].platformDifferences' < ec2.json )
echo "platformDifferences: ${PLATFORMDIFFERENCES}"
#Recommended Options
PERFORMANCERISK=$( jq -r '.instanceRecommendations[].recommendationOptions[].performanceRisk' < ec2.json )
echo "PerformanceRisk: ${PERFORMANCERISK}"
#Recommended Options
RANK=$( jq -r '.instanceRecommendations[].recommendationOptions[].rank' < ec2.json )
echo "Rank: ${RANK}"
#Recommended Options
MIGRATIONEFFORT=$( jq -r '.instanceRecommendations[].recommendationOptions[].migrationEffort' < ec2.json )
echo "Recommended migrationEffort: ${MIGRATIONEFFORT}"

printf "${INSATNCEID}\n${ACCOUNTID}\n${INSTANCETYPE}\n${PROJECTUTILIZATIONMETRICS}" > file.log
chmod 777 file.log
chmod 777 ec2.json

git add *

git commit -m "${INSATNCEID}"

#git config --global push.autoSetupRemote true

#git remote add origin git@github.com:Tinkuch/aws_recommendations.git

git remote -v

git push -u origin "${BRANCH}":"${BRANCH}"

#git push --set-upstream origin "${BRANCH}"

#git push -o merge_request.create

hub pull-request -b main -m "merge "${BRANCH}" approve merge to apply recommendation"

#hub pull-request --browse -m "merge "${BRANCH}" approve merge to apply recommendation"

#git push \
# -o merge_request.create \
# -o merge_request.target=main \
# -o merge_request.title="MR 101" \
# -o merge_request.description="Added new test feature 101"


