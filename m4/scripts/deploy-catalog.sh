#!/bin/bash

# 1. Login OpenShift cluster via oc login -u userXX -p openshift https://OCP4_API_URL 
# 2. Move to userxx-cloudnativeapps project via oc project userXX-cloudnativeapps
# How to run this script: scripts/deploy-catalog.sh

cd catalog-service/

# echo -e "mvn package"        
# mvn clean package spring-boot:repackage -DskipTests

oc new-app -e POSTGRESQL_USER=catalog \
             -e POSTGRESQL_PASSWORD=mysecretpassword \
             -e POSTGRESQL_DATABASE=catalog \
             openshift/postgresql:10 \
             --name=catalog-database
    
oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=catalog -l app=catalog
sleep 5

oc start-build catalog --from-file=target/catalog-1.0.0-SNAPSHOT.jar --follow
sleep 5

oc new-app catalog
sleep 5

oc expose service catalog