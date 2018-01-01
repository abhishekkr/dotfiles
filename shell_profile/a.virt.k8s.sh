
### extract more from https://coreos.com/blog/kubectl-tips-and-tricks

zsh-completion-for-kubectl(){
  source <(kubectl completion zsh)
}

bash-completion-for-kubectl(){
  kubectl completion bash > ~/.kube/completion.bash.inc
  source ~/.kube/completion.bash.inc
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

k8s-pods(){
  local _POD_ID="$1"

  kubectl get pods
}

k8s-pod-get(){
  local _POD_ID="$1"

  kubectl get pod -o json ${_POD_ID}
}

k8s-pod-del(){
  local _POD_ID="$1"

  kubectl delete pod ${_POD_ID}
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
