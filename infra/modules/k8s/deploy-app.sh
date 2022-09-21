#!/bin/bash

echo "INFO $(date) starting to deploy app"

get_env_vars() {
    echo "getting variables"
    export PROJECT_ID=$PROJECT_ID
    export CLUSTER_NAME=$CLUSTER_NAME
    export REGION=$REGION
    export SA_KEY=$SA_KEY
}

set_gcloud() {
    echo "gcloud setup"
    cat <<< "$SA_KEY" > "key.json"
    gcloud auth activate-service-account --key-file key.json    
    gcloud config set project $PROJECT_ID
    gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID
}

deploy_app() {
    echo "deploying app"
    kubectl apply -f ../../modules/k8s/deploy_app.yaml
    kubectl apply -f ../../modules//k8s/nodeport.yaml
    kubectl apply -f ../../modules//k8s/ingress.yaml
}

get_env_vars
set_gcloud
deploy_app