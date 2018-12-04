
### extract more from https://coreos.com/blog/kubectl-tips-and-tricks

zsh-completion-for-kubectl(){
  source <(kubectl completion zsh)
}

bash-completion-for-kubectl(){
  kubectl completion bash > ~/.kube/completion.bash.inc
  source ~/.kube/completion.bash.inc
}

k8scc(){
  kubectl config current-context
}

k8sgc(){
  local _WHICH=" $1"
  kubectl config get-contexts | grep ${_WHICH}
}

k8suc(){
  local _WHICH="$1"
  local _WHICH_CONTEXT=$(kubectl config get-contexts | grep "${_WHICH}" | head -1 | awk '{print $NF}')
  kubectl config use-context ${_WHICH_CONTEXT}
}

k8tail(){
   kubectl logs -f  --tail=100 $@
}

gcp-default-cluster-set(){
  local _GCP_PROJECT="$1"
  local _CLUSTER_ID="$2"
  [[ -z "${_GCP_PROJECT}" ]] && return 1
  [[ -z "${_CLUSTER_ID}" ]] && return 1
  gcloud --project "${_GCP_PROJECT}" config set container/cluster ${_CLUSTER_ID}
}

gcp-k8s-clusters(){
  local _GCP_PROJECT="$1"
  [[ -z "${_GCP_PROJECT}" ]] && return 1
  gcloud --project "${_GCP_PROJECT}" container clusters list
}

k8s-make-admin(){
  local _KUBE_USER_ID="$1"
  [[ -z "${_KUBE_USER_ID}" ]] && echo "usage: k8s-make-admin <user-id>" && return 1
  kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user "${_KUBE_USER_ID}"
}

k8s-pods(){
  local _POD_ID="$1"

  kubectl get po --all-namespaces --no-headers | awk '{print $1","$2}' | grep "${_POD_ID}"
}

k8s-pod-get(){
  local _POD_ID="$1"
  kubectl get pod -o json ${_POD_ID}
}

k8s-get-all-in-ns(){
  [[ $# -ne 1 ]] && \
    echo "usage: k8s-get-all-in-ns <namespace>"
  local NS="$1"
  for res in ds sts deploy rs jobs cronjobs po cm secrets svc ep ing pvc sa roles rolebindings; do
    echo "[+] Listing all ${res} in ${NS}"
    kubectl --namespace=$NS get $res
    echo
  done
}

k8s-pod-del(){
  local _POD_ID="$@"

  kubectl delete pod ${_POD_ID}
}

k8s-del-from-ns-all-res(){
  [[ $# -ne 2 ]] && \
    echo "usage: k8s-del-from-ns-all-res <namespace> <resource-type>"
  kubectl -n $1 get $2 --no-headers=true | awk '{print $1}' | xargs -I{}  kubectl -n $1 delete $2 {}
}

k8s-del-all-in-ns(){
  [[ $# -ne 1 ]] && \
    echo "usage: k8s-del-all-in-ns <namespace>"
  local NS="$1"
  for res in ds sts deploy rs jobs cronjobs po cm secrets svc ep ing pvc sa roles rolebindings; do
    kubectl --namespace=$NS delete --all --ignore-not-found $res
  done
}

helm-del-all-in-ns(){
	[[ $# -ne 1 ]] && echo "usage: helm-del-all-in-ns <namespace>"
	local NS="$1"
	for res in $(helm ls --tiller-namespace $NS | grep -v NAME |awk '{print $1}')
	do
		helm del --purge $res --tiller-namespace $NS &
	done
  wait
}

k8s-del-all(){
  local NS_LIKE="$1"
  [[ -z "${NS_LIKE}" ]] && \
    echo "would not work without namespace pattern; usage: kube-delete-all <ns-pattern>" && \
    echo "to explicitly delete from all namespaces, run$ kube-delete-all '*'" && \
    return 1
  for ns in $(kubectl get namespaces -o jsonpath={..metadata.name}); do
    [[ $(echo $ns | grep -c -E "$NS_LIKE") -lt 1 ]] && continue
		helm-del-all-in-ns $ns
		k8s-del-all-in-ns $ns
  done
}

k8s-deployments-get(){
  kubectl get deployment -o json
  #curl -X GET 'http://127.0.0.1:8001/apis/apps/v1beta1/namespaces/default/deployments'
}

debug(){
  kubectl get pods
  kubectl describe pods ${_POD_ID}
  kubectl logs ${_POD_ID}
}

k8s-which(){
  kubectl config current-context | sed 's/_/ > /g'
}

k8s-switch(){
  local _CONTEXT_PATTERN="$1"
  local _MATCHED_CONTEXT=$(kubectl config get-contexts --no-headers | grep -E "${_CONTEXT_PATTERN}" | awk '{print $1}' | grep -v '*')
  local _CONTEXT=$(echo "${_MATCHED_CONTEXT}" | head -1)
  echo "matched:"
  echo "${_MATCHED_CONTEXT}" | sed 's/_/ > /g'
  echo ""
  kubectl config use-context ${_CONTEXT} > /dev/null
  echo -n "switched to first: "
  k8s-which
}

k8s-exec(){
  local POD_ID="$1"
  kubectl exec -it  ${POD_ID} ${@:2}  -- /bin/bash
}

k8s-hook(){
   kubectl run abk-shell --rm -i --tty --namespace default --image alpine:latest --restart=Never  -- /bin/sh
}

k8s-all(){
  for res in $(kubectl get crd --no-headers --all-namespaces=true | awk '{print $1}'); do
    kubectl get all --all-namespaces=true
  done
}

k8s-sa(){
  local _SA_NAME="$1"
  local _K8S_NAMESPACE="$2"
  kubectl get sa/${_SA_NAME} -n ${_K8S_NAMESPACE}
}

k8s-psql(){
  local USER=${1}
  local DBNAME=${2}
  local DB_SVC="${3}"
  local _NS="${4}"

  [[ $# -ge 3 ]] && \
      echo "usage: k8s-psql <db-user> <db-name> <svc-name> (<namespace>)" && \
      exit 1
  [[ -z "${_NS}" ]] && \
    _NS="default"

  local _PGPASSWORD=$(kubectl-n ${_NS}  get secret alice-db-s-1-stolon-secret -o jsonpath="{.data.password}" | base64 --decode)
  kubectl run pgclient -n ${_NS} --image=postgres --env PGPASSWORD=$_PGPASSWORD -it --rm -- bash -c "psql -U ${USER} -d ${DBNAME} -h ${DB_SVC}"
}
