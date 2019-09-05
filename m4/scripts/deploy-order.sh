#!/bin/bash

# 1. Login OpenShift cluster via oc login -u userXX -p openshift https://OCP4_API_URL 
# 2. Move to userxx-cloudnativeapps project via oc project userXX-cloudnativeapps
# How to run this script: scripts/deploy-order.sh

cd order-service

# echo -e "mvn package"
# mvn clean package -DskipTests
# rm -rf target/binary && mkdir -p target/binary && cp -r target/*runner.jar target/lib target/binary

oc new-app --docker-image mongo:4.0 --name=order-database

oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=order -l app=order
sleep 5

oc start-build order --from-dir=target/binary --follow
sleep 5

oc new-app order
sleep 5

oc expose service order