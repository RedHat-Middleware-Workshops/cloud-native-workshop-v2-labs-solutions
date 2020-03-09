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
oc new-app coolstore-monolith-binary-build -p USER_ID=$USERXX

mvn clean package -Popenshift -f $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m2-labs/monolith/
oc start-build coolstore --from-file $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m2-labs/monolith/deployments/ROOT.war