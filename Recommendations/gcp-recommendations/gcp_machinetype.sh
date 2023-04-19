#!/bin/bash
#THIS SCRIPT IS FOR CALLING GCP RECOMMENDATION API AND STORING THE CONFIG IN 

#git clone git@github.com:ashokdas14/recommenders.git

#DIR=${PWD}

cd /var/lib/jenkins/workspace/recom

BRANCH=${RANDOM}

git checkout -b "${BRANCH}"

#CALLING THE GCP API
PROJECT_ID=$(gcloud config get-value project)
# gcloud recommender recommendations list --recommender=google.compute.instance.MachineTypeRecommender --project=$PROJECT_ID --location=us-east1-b --format=json > machinetype.json

#Description varaibale
DESCRIPTION=$( jq -r '.[].description' < machinetype.json )
echo "${DESCRIPTION}"

#Resource Variable
RESOURCE=$( jq -r '.[].content.overview.resourceName' < machinetype.json )
echo "Resource: ${RESOURCE}"

MACHINETYPE=$( jq -r '.[].content.overview.recommendedMachineType.name' < machinetype.json )
echo "${MACHINETYPE}"

#Recommended Action Variable
ACTION=$( jq -r '.[].recommenderSubtype' < machinetype.json )
echo "Recommended Action: ${ACTION}"
printf "${DESCRIPTION}\n${RESOURCE}\n${MACHINETYPE}\n${ACTION}" > files.log
chmod 777 files.log
chmod 777 machinetype.json

git add *

git commit -m "${DESCRIPTION}"

git push origin "${BRANCH}":"${BRANCH}"

hub pull-request -m "merge "${BRANCH}"approve merge to apply recommendation"