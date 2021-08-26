#!/bin/bash

echo $(date) " - ### Starting Script ###"

AZURE_TENANT_ID=$1
AZURE_SUBSCRIPTION_ID=$2
ADMIN_USER=$3
AZURE_CLIENT_ID=$4
AZURE_CLIENT_SECRET=$5
USER_EMAIL=$6
USER_OBJECT_ID=$7
IOT_CENTRAL_NAME=$8
IOT_CENTRAL_LOCATION=$9
IOT_CENTRAL_SKU=${10}
IOT_CENTRAL_SUBDOMAIN=${11}
IOT_CENTRAL_TEMPLATE=${12}
RESOURCE_GROUP_NAME=${13}

sudo apt-get -y update 
sudo apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg 

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

az extension add --name azure-iot

az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID

az iot central app create -n $IOT_CENTRAL_NAME -g $RESOURCE_GROUP_NAME -s $IOT_CENTRAL_SUBDOMAIN -l $IOT_CENTRAL_LOCATION -p $IOT_CENTRAL_SKU -t $IOT_CENTRAL_TEMPLATE

APP_ID=$(az iot central app list -g $RESOURCE_GROUP_NAME | grep application | awk '{print $2}'| sed 's/^"\(.*\)".*/\1/')

az iot central user create --user-id $USER_OBJECT_ID --app-id $APP_ID --email $USER_EMAIL --role admin
