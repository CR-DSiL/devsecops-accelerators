#!/bin/bash

#THIS SCRIPT WILL FTECH THE GOOGLE RECOMMEDNATION THROUGH GOOGLE API

#DECLARAING THE VARAIABLE
BRANCH=${RANDOM}
PROJECT_ID=$(gcloud config get-value project)
FILENAME=${1}
DIR=$PWD

cd ${DIR}
cat /dev/null > ${DIR}/file.config
cat /dev/null > ${DIR}/ignore_list
cat /dev/null > ${DIR}/project_list
cat /dev/null > ${DIR}/instances
cat /dev/null > ${DIR}/zones
cat /dev/null > ${DIR}/project_id


git checkout -b "${BRANCH}"

#CHECKING FOR THE FILENAME
if [[ ${#} -lt 1 ]]
then
    echo "Kindly provide the filename"
    exit 1
fi

#CHECKING FOR REOMMENDATION AND GENERATING RECOMMENDATION
if [[ ${FILENAME} = "machinetype" ]]
then
    gcloud project list > project_list
    awk '/^PROJECT_ID: /{print $NF}' project_list > project_id
    while read -r PROJ
    do 
        PROJECT_ID="${PROJ}"
        gcloud compute instances list --project ${PROJECT_ID} >> instances
        awk '/^ZONE: /{print $NF}' instances >> zones
        while read -r ZONE
        do
            GCP_LOCATION="${ZONE}"
            #gcloud recommender recommendations list --recommender=google.compute.instance.MachineTypeRecommender --project=$PROJECT_ID --location=$GCP_LOCATION --format=json >> ${FILENAME}.json
            jq -r '.[] | "Description: \(.description)","Resource_Name: \(.content.overview.resourceName)","Etag: \(.etag)","Machine_Type: \(.content.overview.recommendedMachineType.name)","Location: \(.content.overview.location)","Action: \(.recommenderSubtype)"' machinetype.json >> file.config
            chmod 777 file.config
            chmod 777 ${FILENAME}.json
            cat file.config
        done < zones
    done < project_id
fi

if [[ ${FILENAME} = "idleimages" ]]
then
    gcloud project list > project_list
    awk '/^PROJECT_ID: /{print $NF}' project_list > project_id
    while read -r PROJ
    do
        PROJECT_ID="${PROJ}"
        GCP_LOCATION=global
        #gcloud recommender recommendations list --project=$PROJECT_ID --billing-project=$PROJECT_ID --recommender=google.compute.image.IdleResourceRecommender --location=$GCP_LOCATION --format=json >> ${FILENAME}.json
        jq -r '.[] | "Description: \(.description)","Resource_Name: \(.content.overview.resourceName)","Etag: \(.etag)","Location: \(.content.overview.location)","Action:\(.recommenderSubtype)\n"' idleimages.json >> file.config
        chmod 777 file.config
        chmod 777 ${FILENAME}.json
        cat file.config
    done < project_id
fi

git add *
git commit -m "${DESCRIPTION}"
git push origin "${BRANCH}":"${BRANCH}"
hub pull-request -m "merge "${BRANCH}"approve merge to apply recommendation"