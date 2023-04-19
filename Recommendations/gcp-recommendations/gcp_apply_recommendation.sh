#!/bin/bash
cd /var/lib/jenkins/workspace/recommender-apply

RESOURCE_NAME=$( jq -r '.[].content.overview.resourceName' < machinetype.json )
MACHINETYPE=$( jq -r '.[].content.overview.recommendedMachineType.name' < machinetype.json )

printf 'yes' | gcloud compute instances stop $RESOURCE_NAME --zone=us-east1-b

printf 'yes' | gcloud compute instances set-machine-type $RESOURCE_NAME --machine-type $MACHINETYPE --zone=us-east1-b

printf 'yes' | gcloud compute instances start $RESOURCE_NAME --zone=us-east1-b