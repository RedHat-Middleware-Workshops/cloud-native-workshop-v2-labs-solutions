#!/bin/bash

USERXX=$1

if [ -z $USERXX ]
  then
    echo "Usage: Input your username like deploy-catalog.sh user1"
    exit;
fi

echo Your username is $USERXX

echo Deploy Catalog service........

oc project $USERXX-catalog

sed -i "s/userXX/${USERXX}/g" /projects/cloud-native-workshop-v2m2-labs/catalog/src/main/resources/application-openshift.properties

oc new-app -e POSTGRESQL_USER=catalog \
             -e POSTGRESQL_PASSWORD=mysecretpassword \
             -e POSTGRESQL_DATABASE=catalog \
             openshift/postgresql:latest \
             --name=catalog-database

mvn clean package install spring-boot:repackage -DskipTests -f $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m2-labs/catalog/

oc new-build registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:1.5 --binary --name=catalog-springboot -l app=catalog-springboot

if [ ! -z $DELAY ]
  then
    echo Delay is $DELAY
    sleep $DELAY
fi

oc start-build catalog-springboot --from-file $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m2-labs/catalog/target/catalog-1.0.0-SNAPSHOT.jar --follow
oc new-app catalog-springboot -e JAVA_OPTS_APPEND='-Dspring.profiles.active=openshift'
oc expose service catalog-springboot

REPLACEURL="$(oc get route -n $USERXX-catalog | grep catalog | awk '{print $2}')"
sed -i "s/REPLACEURL/${REPLACEURL}/g" /projects/cloud-native-workshop-v2m2-labs/monolith/src/main/webapp/app/services/catalog.js
