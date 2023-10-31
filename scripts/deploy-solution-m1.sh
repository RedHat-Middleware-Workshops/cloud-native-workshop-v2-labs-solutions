#!/bin/bash

USERXX=$1

if [ -z "$USERXX" -o "$USERXX" = "userXX" ]
  then
    echo "Usage: Input your username like deploy-solution-m1.sh user1"
    exit;
fi

echo "Start deploying all services in Module 1 of CCN DevTrack"
echo "Deploying Inventory service........"

oc project $USERXX-inventory || oc new-project $USERXX-inventory
oc delete dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

oc new-app --as-deployment-config -e POSTGRESQL_USER=inventory \
  -e POSTGRESQL_PASSWORD=mysecretpassword \
  -e POSTGRESQL_DATABASE=inventory openshift/postgresql:10-el8 \
  --name=inventory-database

mvn clean package -DskipTests -f $PWD/m1/inventory

oc label dc/inventory-database app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/inventory app.kubernetes.io/part-of=inventory --overwrite && \
oc label dc/inventory-database app.kubernetes.io/part-of=inventory --overwrite && \
oc annotate dc/inventory app.openshift.io/connects-to=inventory-database --overwrite && \
oc annotate dc/inventory app.openshift.io/vcs-ref=ocp-4.14 --overwrite

echo "Deployed Inventory service........"

echo "Deploying Catalog service........"
oc project $USERXX-catalog || oc new-project $USERXX-catalog
oc delete dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

sed -i'' -e "s/userXX/${USERXX}/g" $PWD/m1/catalog/src/main/resources/application-openshift.properties
rm -rf $PWD/m1/catalog/src/main/resources/application-openshift.properties-e

oc new-app --as-deployment-config -e POSTGRESQL_USER=catalog \
             -e POSTGRESQL_PASSWORD=mysecretpassword \
             -e POSTGRESQL_DATABASE=catalog \
             openshift/postgresql:10-el8 \
             --name=catalog-database

mvn clean install -Ddekorate.deploy=true -DskipTests -f $PROJECT_SOURCE/catalog

REPLACEURL=$(oc get route -n $USERXX-catalog catalog-springboot -o jsonpath="{.spec.host}")
sed -i "s/REPLACEURL/${REPLACEURL}/g" $PROJECT_SOURCE/monolith/src/main/webapp/app/services/catalog.js

oc label dc/catalog-database app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/catalog-springboot app.openshift.io/runtime=spring-boot --overwrite && \
oc label dc/catalog-springboot app.kubernetes.io/part-of=catalog --overwrite && \
oc label dc/catalog-database app.kubernetes.io/part-of=catalog --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/connects-to=catalog-database --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/vcs-uri=https://github.com/RedHat-Middleware-Workshops/cloud-native-workshop-v2m2-labs.git --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/vcs-ref=ocp-4.14 --overwrite

echo "Deployed Catalog service........"

echo "Deploying Coolstore service........"
oc project $USERXX-coolstore-dev || oc new-project $USERXX-coolstore-dev
oc delete dc,deployment,bc,build,svc,route,pod,is --all
oc get secret coolstore-secret  || oc delete secret coolstore-secret

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

oc new-app coolstore-monolith-binary-build  --as-deployment-config -p USER_ID=$USERXX

CATALOGHOST=$(oc get route -n $USERXX-catalog catalog-springboot -o jsonpath="{.spec.host}")
echo "CATALOGHOST: $CATALOGHOST"
sed -i'' -e "s/REPLACEURL/$CATALOGHOST/g" $PWD/m1/monolith/src/main/webapp/app/services/catalog.js
rm -rf $PWD/m1/monolith/src/main/webapp/app/services/catalog.js-e

mvn clean package -Popenshift -f $PWD/m1/monolith/

oc start-build coolstore --from-file $PWD/m1/monolith/deployments/ROOT.war

oc label dc/coolstore-postgresql app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/coolstore app.openshift.io/runtime=jboss --overwrite && \
oc label dc/coolstore-postgresql app.kubernetes.io/part-of=coolstore --overwrite && \
oc label dc/coolstore app.kubernetes.io/part-of=coolstore --overwrite && \
oc annotate dc/coolstore app.openshift.io/connects-to=coolstore-postgresql --overwrite && \
oc annotate dc/coolstore app.openshift.io/vcs-uri=https://github.com/RedHat-Middleware-Workshops/cloud-native-workshop-v2m2-labs.git --overwrite && \
oc annotate dc/coolstore app.openshift.io/vcs-ref=ocp-4.14 --overwrite

oc rollout status -w dc/coolstore -n $USERXX-coolstore-dev 

echo "Deployed Coolstore service........"
echo "Finished deploying all services in Module 1 of CCN DevTrack"