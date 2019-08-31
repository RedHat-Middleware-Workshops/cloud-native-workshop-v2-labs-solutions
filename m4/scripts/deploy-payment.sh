#!/bin/bash

# 1. Login OpenShift cluster via oc login -u userXX -p openshift https://OCP4_API_URL 
# 2. Move to userxx-cloudnativeapps project via oc project userXX-cloudnativeapps
# How to run this script: scripts/deploy-payment.sh

cd payment-service

# echo -e "mvn package"
# mvn clean package -DskipTests
# rm -rf target/binary && mkdir -p target/binary && cp -r target/*runner.jar target/lib target/binary

oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=payment-service -l app=payment-service
sleep 5

oc start-build payment-service --from-dir=target/binary --follow
sleep 5

oc new-app payment-service
sleep 5

oc expose service payment-service