#!/bin/bash

#function 
print_green(){
    GREEN=$(printf '\033[36m')
    RESET=$(printf '\033[m')
    printf "%s%s%s\n" "$GREEN" "$*" "$RESET"
}

print_red(){
    RED=$(printf '\033[31m')
    RESET=$(printf '\033[m')
    printf "%s%s%s\n" "$RED" "$*" "$RESET"
}

delete_managed_cluster() {
if [ -z "${OPERATOR_NAMESPACE}" ]; then
	local OPERATOR_NAMESPACE="open-cluster-management-agent-addon"
fi

if [ -z "${KLUSTERLET_NAMESPACE}" ]; then
	local KLUSTERLET_NAMESPACE="open-cluster-management-agent"
fi

KUBECTL=oc

## Force delete klusterlet
print_green "attempt to delete klusterlet"
${KUBECTL} delete klusterlet klusterlet --timeout=60s --ignore-not-found
${KUBECTL} delete namespace ${KLUSTERLET_NAMESPACE} --wait=false --ignore-not-found
print_green "force removing klusterlet"
${KUBECTL} patch klusterlet klusterlet --type="json" -p '[{"op": "remove", "path":"/metadata/finalizers"}]'
print_green "removing klusterlet crd"
${KUBECTL} delete crd klusterlets.operator.open-cluster-management.io --timeout=30s --ignore-not-found

## Force delete all component CRDs if they still exist
local component_crds=(
	applicationmanagers.agent.open-cluster-management.io
	certpolicycontrollers.agent.open-cluster-management.io
	iampolicycontrollers.agent.open-cluster-management.io
	policycontrollers.agent.open-cluster-management.io
	searchcollectors.agent.open-cluster-management.io
	workmanagers.agent.open-cluster-management.io
	appliedmanifestworks.work.open-cluster-management.io
	klusterlets.operator.open-cluster-management.io
)

for crd in "${component_crds[@]}"; do
	print_green "force delete CustomResourceDefinition ${crd} resources..."
	for resource in $(${KUBECTL} get ${crd} -n ${OPERATOR_NAMESPACE}); do
        force_delete_resource ${OPERATOR_NAMESPACE} ${crd} ${resource} --all
	done
	force_delete_crd ${crd} 
done

print_green "force delete namespace ${OPERATOR_NAMESPACE}..."
${KUBECTL} delete namespace ${OPERATOR_NAMESPACE}
until ! oc get ns | grep ${KLUSTERLET_NAMESPACE} ; do sleep 5 ;done
}


delete_mch(){
#!/bin/bash

if [ -z "${OPERATOR_NAMESPACE}" ]; then
	local OPERATOR_NAMESPACE="open-cluster-management"
fi

if [ -z "${KLUSTERLET_NAMESPACE}" ]; then
	local KLUSTERLET_NAMESPACE="open-cluster-management-hub"
fi

KUBECTL=oc

# Force delete klusterlet
print_green "attempt to delete klusterlet"
${KUBECTL} delete klusterlet klusterlet --timeout=60s --ignore-not-found
${KUBECTL} delete namespace ${KLUSTERLET_NAMESPACE} --wait=false --ignore-not-found
print_green "force removing klusterlet"
${KUBECTL} patch klusterlet klusterlet --type="json" -p '[{"op": "remove", "path":"/metadata/finalizers"}]'
print_green "removing klusterlet crd"
${KUBECTL} delete crd klusterlets.operator.open-cluster-management.io --timeout=30s --ignore-not-found

# Force delete all component CRDs if they still exist
local component_crds=(
    addondeploymentconfigs.addon.open-cluster-management.io
    addonplacementscores.cluster.open-cluster-management.io
    appliedmanifestworks.work.open-cluster-management.io
    backupschedules.cluster.open-cluster-management.io
    channels.apps.open-cluster-management.io
    clusterclaims.cluster.open-cluster-management.io
    clustercurators.cluster.open-cluster-management.io
    clustermanagementaddons.addon.open-cluster-management.io
    clustermanagers.operator.open-cluster-management.io
    deployables.apps.open-cluster-management.io
    discoveredclusters.discovery.open-cluster-management.io
    discoveryconfigs.discovery.open-cluster-management.io
    gitopsclusters.apps.open-cluster-management.io
    helmreleases.apps.open-cluster-management.io
    klusterletaddonconfigs.agent.open-cluster-management.io
    managedclusteractions.action.open-cluster-management.io
    managedclusterimageregistries.imageregistry.open-cluster-management.io
    managedclusterinfos.internal.open-cluster-management.io
    managedclusters.cluster.open-cluster-management.io
    managedclustersetbindings.cluster.open-cluster-management.io
    managedclustersets.cluster.open-cluster-management.io
    managedclusterviews.view.open-cluster-management.io
    managedproxyconfigurations.proxy.open-cluster-management.io
    managedproxyserviceresolvers.proxy.open-cluster-management.io
    manifestworks.work.open-cluster-management.io
    multiclusterhubs.operator.open-cluster-management.io
    multiclusterobservabilities.observability.open-cluster-management.io
    observabilityaddons.observability.open-cluster-management.io
    placementbindings.policy.open-cluster-management.io
    placementdecisions.cluster.open-cluster-management.io
    placementrules.apps.open-cluster-management.io
    placements.cluster.open-cluster-management.io
    policies.policy.open-cluster-management.io
    policyautomations.policy.open-cluster-management.io
    policysets.policy.open-cluster-management.io
    restores.cluster.open-cluster-management.io
    searches.search.open-cluster-management.io
    submarinerconfigs.submarineraddon.open-cluster-management.io
    submarinerdiagnoseconfigs.submarineraddon.open-cluster-management.io
    subscriptionreports.apps.open-cluster-management.io
    subscriptions.apps.open-cluster-management.io
    subscriptionstatuses.apps.open-cluster-management.io
    userpreferences.console.open-cluster-management.io
)

for crd in "${component_crds[@]}"; do
	print_green "force delete CustomResourceDefinition ${crd} resources..." 
	for resource in $(${KUBECTL} get ${crd} -n ${OPERATOR_NAMESPACE}); do
        force_delete_resource ${OPERATOR_NAMESPACE} ${crd} ${resource} --all
	done
	force_delete_crd ${crd}
done

print_green "delete namespace ${OPERATOR_NAMESPACE}..."
${KUBECTL} delete csv -n ${OPERATOR_NAMESPACE} --all --ignore-not-found
${KUBECTL} delete ip -n ${OPERATOR_NAMESPACE} --all --ignore-not-found
${KUBECTL} delete og -n ${OPERATOR_NAMESPACE} --all --ignore-not-found
${KUBECTL} delete sub -n ${OPERATOR_NAMESPACE} --all --ignore-not-found
${KUBECTL} delete namespace ${OPERATOR_NAMESPACE}
}

force_delete_resource(){
local OPERATOR_NAMESPACE=$1
local RESOURCE_TYPE=$2
local RESOURCE_NAME=$3
local timeout=${timeout:-60}


print_green "attempt to delete ${RESOURCE_TYPE} ${RESOURCE_NAME} in namespace ${OPERATOR_NAMESPACE}..."

oc delete ${RESOURCE_TYPE} -n ${OPERATOR_NAMESPACE} ${RESOURCE_NAME} --timeout=${timeout}s --ignore-not-found
if oc get ${RESOURCE_TYPE} -n ${OPERATOR_NAMESPACE} ${RESOURCE_NAME} &>/dev/null ;then
    print_green "cannot remove ${RESOURCE_TYPE} ${RESOURCE_NAME} in namespace ${OPERATOR_NAMESPACE}, force remove ..."
    oc patch ${RESOURCE_TYPE} -n ${OPERATOR_NAMESPACE} ${RESOURCE_NAME} --type="json" -p '[{"op": "remove", "path":"/metadata/finalizers"}]'
    print_green "completed delete ${RESOURCE_TYPE} ${RESOURCE_NAME} in namespace ${OPERATOR_NAMESPACE}..."
fi
}

force_delete_crd(){
local RESOURCE_TYPE=$1
local timeout=${timeout:-30}

print_green "attempt to delete CRD ${RESOURCE_TYPE}..."

oc delete crd ${RESOURCE_TYPE} --timeout=${timeout}s --ignore-not-found
if oc get crd ${RESOURCE_TYPE} &>/dev/null;then
    print_red "cannot remove CRD ${RESOURCE_TYPE}, start remove it force..."
    oc patch crd ${RESOURCE_TYPE}  --type="json" -p '[{"op": "remove", "path":"/metadata/finalizers"}]'
    print_green "completed delete CRD ${RESOURCE_TYPE}..."
fi
}
####################################
####################################
####################################

#MAIN FUNCTION
#uninstall agentserviceconfig
oc delete agentserviceconfig agent

#uninstall managedcluster
print_green "attempt to delete all managedcluster"
oc delete managedcluster --all
delete_managed_cluster

#uninstall MCH&ACM
print_green "attempt to delete MCH&&ACM"
oc delete mch -n open-cluster-management multiclusterhub --timeout=300s
delete_mch

oc delete mce multiclusterengine
oc delete csv,ip,og,sub -n multicluster-engine --all
oc delete ns multicluster-engine






