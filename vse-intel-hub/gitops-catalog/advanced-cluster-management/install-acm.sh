#!/bin/bash


oc apply -k /home/test/ztp/vse-intel-hub/core/advanced-cluster-management/


until oc apply -f /home/test/ztp/vse-intel-hub/core/assisted-service/02-agentserviceconfig.yaml;do echo "apply asc fail"; done
