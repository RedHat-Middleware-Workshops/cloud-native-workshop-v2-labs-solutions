#!/bin/bash

# 1. Login OpenShift cluster via oc login -u userXX -p openshift https://OCP4_API_URL 
# 2. Move to userxx-cloudnativeapps project via oc project userXX-cloudnativeapps
# How to run this script: scripts/deploy-inventory.sh

cd inventory-service

# echo -e "mvn package"
# mvn clean package -DskipTests -Dservice.profile=prod
# rm -rf target/binary && mkdir -p target/binary && cp -r target/*runner.jar target/lib target/binary

oc new-app -e POSTGRESQL_USER=inventory \
  -e POSTGRESQL_PASSWORD=mysecretpassword \
  -e POSTGRESQL_DATABASE=inventory openshift/postgresql:10 \
  --name=inventory-database

oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=inventory-service -l app=inventory-service
sleep 5

oc start-build inventory-service --from-dir=target/binary --follow
sleep 5

oc new-app inventory-service -e QUARKUS_DATASOURCE_URL=jdbc:postgresql://inventory-database:5432/inventory
sleep 5

oc expose service inventory-service