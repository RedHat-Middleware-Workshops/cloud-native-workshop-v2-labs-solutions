#!/bin/bash

USERXX=$1

if [ -z $USERXX ]
  then
    echo "Usage: Input your username like deploy-boolstore.sh user1"
    exit;
fi

echo Your username is $USERXX

echo Deploy coolstore project........

oc new-project $USERXX-coolstore-dev
oc new-app coolstore-monolith-binary-build

cd /projects/cloud-native-workshop-v2m2-labs/monolith/
mvn clean package -Popenshift
oc start-build coolstore --from-file=deployments/ROOT.war
oc rollout status -w dc/coolstore