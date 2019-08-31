#!/bin/bash

# 1. Login OpenShift cluster via oc login -u userXX -p openshift https://OCP4_API_URL 
# 2. Move to userxx-cloudnativeapps project via oc project userXX-cloudnativeapps
# How to run this script: scripts/deploy-all.sh

scripts/deploy-inventory.sh
scripts/deploy-catalog.sh
scripts/deploy-cart.sh
scripts/deploy-order.sh
scripts/deploy-payment.sh
scripts/deploy-webui.sh