#!/bin/bash

USERXX=$1

if [ -z "$USERXX" -o "$USERXX" = "userXX" ]
  then
    echo "Usage: Input your username like deploy-solution-m2.sh user1"
    exit;
fi

echo "Start deploying all services in Module 2 of CCN DevTrack"

echo "Deploying Inventory service........"

oc project $USERXX-inventory || oc new-project $USERXX-inventory
oc delete dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

oc new-app --as-deployment-config -e POSTGRESQL_USER=inventory \
  -e POSTGRESQL_PASSWORD=mysecretpassword \
  -e POSTGRESQL_DATABASE=inventory openshift/postgresql:latest \
  --name=inventory-database

sed -i'' -e "s/userXX/${USERXX}/g" $PWD/m2/inventory/src/main/resources/application.properties
rm -rf $PWD/m2/inventory/src/main/resources/application.properties-e

mvn clean package -DskipTests -f $PWD/m2/inventory

oc label dc/inventory-database app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/inventory app.kubernetes.io/part-of=inventory --overwrite && \
oc label dc/inventory-database app.kubernetes.io/part-of=inventory --overwrite && \
oc annotate dc/inventory app.openshift.io/connects-to=inventory-database --overwrite && \
oc annotate dc/inventory app.openshift.io/vcs-ref=ocp-4.7 --overwrite

echo "Deployed Inventory service........"

echo "Deploying Catalog service........"
oc project $USERXX-catalog || oc new-project $USERXX-catalog
oc delete dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

sed -i'' -e "s/userXX/${USERXX}/g" $PWD/m2/catalog/src/main/resources/application-openshift.properties
rm -rf $PWD/m2/catalog/src/main/resources/application-openshift.properties-e

oc new-app --as-deployment-config -e POSTGRESQL_USER=catalog \
             -e POSTGRESQL_PASSWORD=mysecretpassword \
             -e POSTGRESQL_DATABASE=catalog \
             openshift/postgresql:latest \
             --name=catalog-database

mvn clean install spring-boot:repackage -DskipTests -f $PWD/m2/catalog

oc new-build registry.access.redhat.com/ubi8/openjdk-11 --binary --name=catalog-springboot -l app=catalog-springboot

sleep $DELAY

oc start-build catalog-springboot --from-file $PWD/m2/catalog/target/catalog-1.0.0-SNAPSHOT.jar --follow
oc new-app catalog-springboot --as-deployment-config -e JAVA_OPTS_APPEND='-Dspring.profiles.active=openshift'

oc expose service catalog-springboot

oc label dc/catalog-database app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/catalog-springboot app.openshift.io/runtime=spring --overwrite && \
oc label dc/catalog-springboot app.kubernetes.io/part-of=catalog --overwrite && \
oc label dc/catalog-database app.kubernetes.io/part-of=catalog --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/connects-to=catalog-database --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/vcs-uri=https://github.com/RedHat-Middleware-Workshops/cloud-native-workshop-v2m3-labs.git --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/vcs-ref=ocp-4.7 --overwrite
echo "Deployed Catalog service........"

echo "Deploying Coolstore DEV service........"
oc project $USERXX-coolstore-dev || oc new-project $USERXX-coolstore-dev
oc delete dc,deployment,bc,build,svc,route,pod,is --all
oc get secret coolstore-secret  || oc delete secret coolstore-secret

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

oc new-app coolstore-monolith-binary-build  --as-deployment-config -p USER_ID=$USERXX

CATALOGHOST=$(oc get route -n $USERXX-catalog catalog-springboot -o jsonpath="{.spec.host}")
echo "CATALOGHOST: $CATALOGHOST"
sed -i'' -e "s/REPLACEURL/$CATALOGHOST/g" $PWD/m2/monolith/src/main/webapp/app/services/catalog.js
rm -rf $PWD/m2/monolith/src/main/webapp/app/services/catalog.js-e

mvn clean package -Popenshift -f $PWD/m2/monolith/

oc start-build coolstore --from-file $PWD/m2/monolith/deployments/ROOT.war

oc label dc/coolstore-postgresql app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/coolstore app.openshift.io/runtime=jboss --overwrite && \
oc label dc/coolstore-postgresql app.kubernetes.io/part-of=coolstore --overwrite && \
oc label dc/coolstore app.kubernetes.io/part-of=coolstore --overwrite && \
oc annotate dc/coolstore app.openshift.io/connects-to=coolstore-postgresql --overwrite && \
oc annotate dc/coolstore app.openshift.io/vcs-uri=https://github.com/RedHat-Middleware-Workshops/cloud-native-workshop-v2m2-labs.git --overwrite && \
oc annotate dc/coolstore app.openshift.io/vcs-ref=ocp-4.7 --overwrite

oc rollout status -w dc/coolstore -n $USERXX-coolstore-dev 
echo "Deployed Coolstore DEV service........"

echo "Deploying Coolstore PROD service........"
oc project $USERXX-coolstore-prod || oc new-project $USERXX-coolstore-prod
oc delete dc,deployment,bc,build,svc,route,pod,is --all
oc get secrets coolstore-prod-secret  || oc delete secrets coolstore-prod-secret

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

oc new-app coolstore-monolith-pipeline-build --as-deployment-config -p USER_ID=$USERXX

oc label dc/coolstore-prod-postgresql app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/coolstore-prod app.openshift.io/runtime=jboss --overwrite && \
oc label dc/coolstore-prod-postgresql app.kubernetes.io/part-of=coolstore-prod --overwrite && \
oc label dc/coolstore-prod app.kubernetes.io/part-of=coolstore-prod --overwrite && \
oc annotate dc/coolstore-prod app.openshift.io/connects-to=coolstore-prod-postgresql --overwrite && \
oc annotate dc/coolstore-prod app.openshift.io/vcs-uri=https://github.com/RedHat-Middleware-Workshops/cloud-native-workshop-v2m2-labs.git --overwrite && \
oc annotate dc/coolstore-prod app.openshift.io/vcs-ref=ocp-4.7 --overwrite

oc new-app jenkins-ephemeral --as-deployment-config -p MEMORY_LIMIT=2Gi
oc label dc/jenkins app.openshift.io/runtime=jenkins --overwrite

oc start-build monolith-pipeline
oc rollout status -w dc/coolstore-prod -n $USERXX-coolstore-prod 
echo "Deployed Coolstore PROD service........"

echo "Deploying Monitoring service........"
oc project $USERXX-monitoring || oc new-project $USERXX-monitoring
oc delete dc,deployment,bc,build,svc,route,pod,is --all

oc get configmaps jenkins-trusted-ca-bundle || oc delete configmaps jenkins-trusted-ca-bundle
oc get serviceaccounts jenkins || oc delete serviceaccounts jenkins

cat <<EOF | oc apply -n $USERXX-monitoring -f -
apiVersion: jaegertracing.io/v1
kind: Jaeger
metadata:
  name: jaeger-all-in-one-inmemory
  namespace: $USERXX-monitoring
EOF

oc new-app prom/prometheus:latest
oc expose svc prometheus
oc new-app grafana/grafana:latest
oc expose svc grafana

cat <<EOF | oc apply -n $USERXX-monitoring -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: $USERXX-monitoring
data:
  prometheus.yml: >-
    scrape_configs:
      - job_name: 'prometheus'
        static_configs:
        - targets: ['localhost:9090']

      - job_name: 'inventory-quarkus'
        scrape_interval: 10s
        scrape_timeout: 5s
        static_configs:
        - targets: ['inventory.$USERXX-inventory.svc.cluster.local']
EOF

oc set volume -n $USERXX-monitoring deployment/prometheus --add -t configmap --configmap-name=prometheus-config -m /etc/prometheus/prometheus.yml --sub-path=prometheus.yml && \
oc rollout status -n $USERXX-monitoring -w deployment/prometheus
echo "Deployed Monitoring service........"

echo "Finished deploying all services in Module 2 of CCN DevTrack"