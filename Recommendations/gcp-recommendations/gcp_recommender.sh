#!/bin/bash
#THIS SCRIPT IS FOR CALLING GCP RECOMMENDATION API AND STORING THE CONFIG IN 

#git clone git@github.com:ashokdas14/recommenders.git

#DIR=${PWD}

cd /var/lib/jenkins/workspace/recom

BRANCH=${RANDOM}

git checkout -b "${BRANCH}"

#CALLING THE GCP API
PROJECT_ID=$(gcloud config get-value project)
# gcloud recommender recommendations list --project=$PROJECT_ID --billing-project=$PROJECT_ID --recommender=google.compute.image.IdleResourceRecommender --location=global --format=json > idleimages.json

#Description varaibale
DESCRIPTION=$( jq -r '.[].description' < idleimages.json )
echo "${DESCRIPTION}"

#Resource Variable
RESOURCE=$( jq -r '.[].content.operationGroups[].operations[].resource' < idleimages.json )
echo "Resource: ${RESOURCE}"

#Recommended Action Variable
ACTION=$( jq -r '.[].recommenderSubtype' < idleimages.json )
echo "Recommended Action: ${ACTION}"
printf "${DESCRIPTION}\n${RESOURCE}\n${ACTION}" > file.log
chmod 777 file.log
chmod 777 idleimages.json

git add *

git commit -m "${DESCRIPTION}"

git push origin "${BRANCH}":"${BRANCH}"

hub pull-request -m "merge "${BRANCH}"approve merge to apply recommendation"