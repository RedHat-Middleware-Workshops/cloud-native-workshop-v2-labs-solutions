#!/bin/bash

USERXX=$1

if [ -z "$USERXX" -o "$USERXX" = "userXX" ]
  then
    echo "Usage: Input your username like deploy-solution-m3.sh user1"
    exit;
fi

echo "Start deploying all services in Module 3 of CCN DevTrack"

echo "Deploying Bookinfo service........"
oc project $USERXX-bookinfo
oc delete all --all -n $USERXX-bookinfo

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

cat <<EOF | oc apply -n $USERXX-istio-system  -f -
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: $USERXX-istio-system 
spec:
  members:
    - $USERXX-bookinfo 
    - $USERXX-catalog
    - $USERXX-inventory
EOF

oc apply -n $USERXX-bookinfo -f $PWD/m3/istio/bookinfo.yaml
oc apply -n $USERXX-bookinfo -f $PWD/m3/istio/bookinfo-gateway.yaml

ISTIOHOST=$(oc get route istio-ingressgateway -n $USERXX-istio-system -o jsonpath="{.spec.host}")
PATCH_VS="oc patch -n $USERXX-bookinfo virtualservice/bookinfo --type='json' -p '[{\"op\":\"add\",\"path\":\"/spec/hosts\",\"value\": ["\"$ISTIOHOST\""]}]'"
echo "PATCH_VS: $PATCH_VS"
eval $PATCH_VS

oc apply -n $USERXX-bookinfo -f $PWD/m3/istio/destination-rule-all.yaml

oc label deployment/productpage-v1 app.openshift.io/runtime=python --overwrite && \
oc label deployment/details-v1 app.openshift.io/runtime=ruby --overwrite && \
oc label deployment/reviews-v1 app.openshift.io/runtime=java --overwrite && \
oc label deployment/reviews-v2 app.openshift.io/runtime=java --overwrite && \
oc label deployment/reviews-v3 app.openshift.io/runtime=java --overwrite && \
oc label deployment/ratings-v1 app.openshift.io/runtime=nodejs --overwrite && \
oc label deployment/details-v1 app.kubernetes.io/part-of=bookinfo --overwrite && \
oc label deployment/productpage-v1 app.kubernetes.io/part-of=bookinfo --overwrite && \
oc label deployment/ratings-v1 app.kubernetes.io/part-of=bookinfo --overwrite && \
oc label deployment/reviews-v1 app.kubernetes.io/part-of=bookinfo --overwrite && \
oc label deployment/reviews-v2 app.kubernetes.io/part-of=bookinfo --overwrite && \
oc label deployment/reviews-v3 app.kubernetes.io/part-of=bookinfo --overwrite && \
oc annotate deployment/productpage-v1 app.openshift.io/connects-to=reviews-v1,reviews-v2,reviews-v3,details-v1 && \
oc annotate deployment/reviews-v2 app.openshift.io/connects-to=ratings-v1 && \
oc annotate deployment/reviews-v3 app.openshift.io/connects-to=ratings-v1

 oc rollout status -n $USERXX-bookinfo -w deployment/productpage-v1 && \
 oc rollout status -n $USERXX-bookinfo -w deployment/reviews-v1 && \
 oc rollout status -n $USERXX-bookinfo -w deployment/reviews-v2 && \
 oc rollout status -n $USERXX-bookinfo -w deployment/reviews-v3 && \
 oc rollout status -n $USERXX-bookinfo -w deployment/details-v1 && \
 oc rollout status -n $USERXX-bookinfo -w deployment/ratings-v1

 oc get pods -n $USERXX-bookinfo --selector app=reviews
echo "Deployed Bookinfo service........"

echo "Deploying Inventory service........"
oc project $USERXX-inventory || oc new-project $USERXX-inventory
oc delete dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

oc new-app --as-deployment-config -e POSTGRESQL_USER=inventory \
  -e POSTGRESQL_PASSWORD=mysecretpassword \
  -e POSTGRESQL_DATABASE=inventory openshift/postgresql:10-el8 \
  --name=inventory-database

mvn clean package -DskipTests -f $PWD/m3/inventory

oc label dc/inventory-database app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/inventory app.kubernetes.io/part-of=inventory --overwrite && \
oc label dc/inventory-database app.kubernetes.io/part-of=inventory --overwrite && \
oc annotate dc/inventory app.openshift.io/connects-to=inventory-database --overwrite && \
oc annotate dc/inventory app.openshift.io/vcs-ref=ocp-4.12 --overwrite

oc patch dc/inventory-database -n ${USERXX}-inventory --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc rollout status -w dc/inventory-database -n ${USERXX}-inventory

oc patch dc/inventory -n ${USERXX}-inventory --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc rollout latest dc/inventory -n ${USERXX}-inventory && \
oc rollout status -w dc/inventory -n ${USERXX}-inventory 

oc get pods -n ${USERXX}-inventory --field-selector status.phase=Running
echo "Deployed Inventory service........"

echo "Deploying Catalog service........"
oc project $USERXX-catalog || oc new-project $USERXX-catalog
oc delete dc,deployment,bc,build,svc,route,pod,is --all
oc delete VirtualService catalog-default -n $USERXX-catalog
oc delete RequestAuthentication calalog-req-auth -n $USERXX-catalog
oc delete AuthorizationPolicy catalog-auth-policy -n $USERXX-catalog

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

sed -i'' -e "s/userXX/${USERXX}/g" $PWD/m3/catalog/src/main/resources/application-openshift.properties
rm -rf $PWD/m3/catalog/src/main/resources/application-openshift.properties-e

oc new-app --as-deployment-config -e POSTGRESQL_USER=catalog \
             -e POSTGRESQL_PASSWORD=mysecretpassword \
             -e POSTGRESQL_DATABASE=catalog \
             openshift/postgresql:10-el8 \
             --name=catalog-database

mvn clean install spring-boot:repackage -DskipTests -f $PWD/m3/catalog

oc new-build registry.access.redhat.com/ubi8/openjdk-17:1.14 --binary --name=catalog-springboot -l app=catalog-springboot

oc start-build catalog-springboot --from-file $PWD/m3/catalog/target/catalog-1.0.0-SNAPSHOT.jar --follow
oc new-app catalog-springboot --as-deployment-config -e JAVA_OPTS_APPEND='-Dspring.profiles.active=openshift'

oc label dc/catalog-database app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/catalog-springboot app.openshift.io/runtime=spring --overwrite && \
oc label dc/catalog-springboot app.kubernetes.io/part-of=catalog --overwrite && \
oc label dc/catalog-database app.kubernetes.io/part-of=catalog --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/connects-to=catalog-database --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/vcs-uri=https://github.com/RedHat-Middleware-Workshops/cloud-native-workshop-v2m3-labs.git --overwrite && \
oc annotate dc/catalog-springboot app.openshift.io/vcs-ref=ocp-4.12 --overwrite

oc patch dc/catalog-database -n ${USERXX}-catalog --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc rollout status -w dc/catalog-database -n ${USERXX}-catalog

oc patch dc/catalog-springboot -n ${USERXX}-catalog --type='json' -p '[{"op":"add","path":"/spec/template/metadata/annotations", "value": {"sidecar.istio.io/inject": "'"true"'"}}]' && \
oc rollout status -w dc/catalog-springboot -n ${USERXX}-catalog

oc get pods -n ${USERXX}-catalog --field-selector="status.phase=Running"

sed -i'' -e "s/userXX/$USERXX/g" $PWD/m3/catalog/rules/catalog-default.yaml
sed -i'' -e "s/REPLACEURL/$ISTIOHOST/g" $PWD/m3/catalog/rules/catalog-default.yaml
rm -rf $PWD/m3/catalog/rules/catalog-default.yaml-e
oc create -f $PWD/m3/catalog/rules/catalog-default.yaml -n $USERXX-catalog
echo "Deployed Catalog service........"

echo "Deploying RH-SSO service........"
oc project $USERXX-rhsso || oc new-project $USERXX-rhsso
oc delete dc,deployment,bc,build,svc,route,pod,is --all

echo "Waiting 30 seconds to finialize deletion of resources..."
sleep 30

oc new-app ccn-sso74 --as-deployment-config -p SSO_ADMIN_USERNAME=admin -p SSO_ADMIN_PASSWORD=admin

oc label dc/sso app.openshift.io/runtime=sso && \
oc label dc/sso-postgresql app.openshift.io/runtime=postgresql --overwrite && \
oc label dc/sso-postgresql app.kubernetes.io/part-of=sso --overwrite && \
oc label dc/sso app.kubernetes.io/part-of=sso --overwrite && \
oc annotate dc/sso-postgresql app.openshift.io/connects-to=sso --overwrite
oc rollout status dc/sso
oc rollout status dc/sso-postgresql

sleep 10

sed -i'' -e "s/REPLACEURL/$ISTIOHOST/g" $PWD/scripts/ccn-istio-realm.json
rm -rf $PWD/scripts/ccn-istio-realm.json-e

RHSSO_SEC_RT=$(oc get route -n $USERXX-rhsso secure-sso -o jsonpath="{.spec.host}")
echo "RHSSO_RT: $RHSSO_SEC_RT"

SSO_TOKEN=$(curl -s -d "username=admin&password=admin&grant_type=password&client_id=admin-cli" \
  -X POST https://$RHSSO_SEC_RT/auth/realms/master/protocol/openid-connect/token | \
  jq  -r '.access_token')
echo $SSO_TOKEN

curl -w "\n" -v -H "Authorization: Bearer ${SSO_TOKEN}" -H "Content-Type:application/json" -d @${PWD}/scripts/ccn-istio-realm.json \
  -X POST "https://$RHSSO_SEC_RT/auth/admin/realms"

SSO_TOKEN=$(curl -s -d "username=admin&password=admin&grant_type=password&client_id=admin-cli" \
  -X POST https://$RHSSO_SEC_RT/auth/realms/master/protocol/openid-connect/token | \
  jq  -r '.access_token')
echo $SSO_TOKEN

# Create an Authuser
curl -w "\n" -v -H "Authorization: Bearer ${SSO_TOKEN}" -H "Content-Type:application/json" -d '{"username":"auth'${USERXX}'","enabled":true,"emailVerified": true,"firstName": "auth'${USERXX}'","lastName": "Developer","email": "'${USERXX}'@no-reply.com", "credentials":[{"type":"password","value":"r3dh4t1!","temporary":false}]}' -X POST "https://$RHSSO_SEC_RT/auth/admin/realms/istio/users"

AUTH_USERID=$(curl -w "\n" -v -H "Authorization: Bearer ${SSO_TOKEN}" -H "Content-Type:application/json"  "https://$RHSSO_SEC_RT/auth/admin/realms/istio/users" | jq -r '.[0] .id')
echo $AUTH_USERID

# Role Mapping
curl -w "\n" -v -H "Authorization: Bearer ${SSO_TOKEN}" -H "Content-Type:application/json" -d '[{"id": "a08a2cec-4d46-4535-bf5a-c5238fe89570","name": "ccn_auth"}]' -X POST "https://$RHSSO_SEC_RT/auth/admin/realms/istio/users/$AUTH_USERID/role-mappings/realm"
echo "Deployed RH-SSO service........"

echo "Enabling RH-SSO service........"
oc patch -n $USERXX-catalog svc/catalog-springboot -p '{"spec": {"ports":[{"port": 8080, "name": "http"}, {"port": 8443, "name": "https"}]}}'

RHSSO_RT=$(oc get route -n $USERXX-rhsso sso -o jsonpath="{.spec.host}")
echo "RHSSO_RT: $RHSSO_RT"
sed -i'' -e "s/userXX/$USERXX/g" $PWD/m3/catalog/rules/ccn-auth-config.yaml
sed -i'' -e "s/REPLACEURL/$RHSSO_RT/g" $PWD/m3/catalog/rules/ccn-auth-config.yaml
oc create -f $PWD/m3/catalog/rules/ccn-auth-config.yaml -n $USERXX-catalog
rm -rf $PWD/m3/catalog/rules/ccn-auth-config.yaml-e

oc rollout latest dc/inventory -n ${USERXX}-inventory && \
oc rollout status -w dc/inventory -n ${USERXX}-inventory 

curl -i http://$ISTIOHOST

export TOKEN=$( curl -s -X POST http://$RHSSO_RT/auth/realms/istio/protocol/openid-connect/token \
 -H "Content-Type: application/x-www-form-urlencoded" \
 -d "username=auth$USERXX" \
 -d 'password=r3dh4t1!' \
 -d 'grant_type=password' \
 -d 'client_id=ccn-cli' | jq -r '.access_token')  && echo $TOKEN;

# If you have failed with "Jwks doesn't have key to match kid or alg from Jwt%" or "parse error: Invalid numeric literal at line 1, column 5"
# Then, retry it after a few mins since it sometimes need to take a few minutes to apply for the authentication.
curl -s -H "Authorization: Bearer $TOKEN" http://$ISTIOHOST/services/products | jq

echo "Enabled RH-SSO service........"

echo "Finished deploying all services in Module 3 of CCN DevTrack"