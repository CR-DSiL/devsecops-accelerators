#!/bin/bash

#THIS SCRIPT WILL APPLY THE RECOMMENDATION WHICH ARE APPROVED BY REVIEWER

cd /var/lib/jenkins/workspace/recommender-apply

#DECLARING THE VARAIABLES
RECOMMEDNATION="/tmp/recommendation"
# tail -n1 file.config > ${RECOMMEDNATION}
awk 
read RECOMMENDED < ${RECOMMEDNATION}

if [[ ${RECOMMENDED} = CHANGE_MACHINE_TYPE ]]
then
    echo "${RECOMMENDED}"
    sed -n '/Resource Name:/,/Machine Type:/{/Resource Name:/!{/Machine Type:/!p}}' file.config > resources
     
    while read -r RESOURCE
    do
        RESOURCE_NAME="${RESOURCE}"
        while read -r IGNORE_RESOURCES
        do
            IGNORE_LIST="${IGNORE_RESOURCES}"
            if [[ ${RESOURCE_NAME} != ${IGNORE_LIST} ]]
            then
                sed -n '/Machine Type:/,/Location:/{/Machine Type:/!{/Location:/!p}}' file.config > machinetype
                while read -r MACHINE
                do
                    MACHINETYPE="${MACHINE}"
                    echo "Resource Name: ${RESOURCE_NAME}"
                    echo "Machine Type: ${MACHINETYPE}"
                    printf 'yes' | gcloud compute instances stop $RESOURCE_NAME --zone=us-east1-b
                    printf 'yes' | gcloud compute instances set-machine-type $RESOURCE_NAME --machine-type $MACHINETYPE --zone=us-east1-b
                    printf 'yes' | gcloud compute instances start $RESOURCE_NAME --zone=us-east1-b
                done < machinetype
            else
                while read -r IGNORE
                do
                    IGNORE_RESOURCES="${IGNORE}"
                    echo "Ignore_Resource_Name: ${IGNORE}\n"
                    ETAG=$( jq -r --arg IGNORE_RESOURCES "$IGNORE_RESOURCES" '.[] | select(.content.overview.resourceName == $IGNORE_RESOURCES) | .etag' machinetype.json )
                    jq -r --arg IGNORE_RESOURCES "$IGNORE_RESOURCES" '.[] | select(.content.overview.resourceName == $IGNORE_RESOURCES) | .name' machinetype.json > NAME
                    jq -r --arg IGNORE_RESOURCES "$IGNORE_RESOURCES" '.[] | select(.content.overview.resourceName == $IGNORE_RESOURCES) | .content.overview.resource' machinetype.json > RESOURCE
                    while read -r LINE
                    do 
                        RECOMMEDNATION="${LINE#*/recommendations/*}"
                        RECOMMEDNATION="${RECOMMENDATION%%/*}" 
                        RECOMMENDATION_ID="${RECOMMENDATION}" 
                        echo "${RECOMMENDATION_ID}"
                    done < NAME
                    while read -r LINE
                    do 
                        PROJECT="${LINE#*/projects/*}"
                        PROJECT="${PROJECT%%/*}" 
                        PROJECT_ID="${PROJECT}" 
                        echo "${PROJECT_ID}"
                    done < RESOURCE
                    while read -r LINE
                    do 
                        LOCATION="${LINE#*/locations/*}"
                        LOCATION="${LOCATION%%/*}" 
                        LOCATION_ID="${LOCATION}" 
                        echo "${LOCATION_ID}"
                    done < NAME
                    printf 'yes' | gcloud recommender recommendations mark-succeeded $RECOMMENDATION_ID --project=$PROJECT_ID --location=$LOCATION_ID --recommender=google.compute.instance.MachineTypeRecommender --etag=$ETAG --format=json
            fi 
        done < ignore_list
    done < resource
fi

if [[ ${RECOMMENDED} = DELETE_IMAGE ]]
then
    echo "${RECOMMENDED}"
    sed -n '/Resource Name:/,/Location:/{/Resource Name:/!{/Location:/!p}}' file.config > resources
    while read -r RESOURCE
    do
        RESOURCE_NAME="${RESOURCE}"
        while read -r IGNORE_RESOURCES
        do
            IGNORE_LIST="${IGNORE_RESOURCES}"
            if [[ ${RESOURCE_NAME} != ${IGNORE_LIST} ]]
            then
                echo "Resource Name: ${RESOURCE_NAME}"
                printf 'yes' | gcloud compute images delete $RESOURCE_NAME
            fi 
        done < ignore_list
    done < resource
fi
