alias gcloud-serialout="gcloud beta compute instances get-serial-port-output"

alias gcloud-config="gcloud config list"

alias gcloud-prj="gcloud projects list"

gcp-default-project-set(){
  local _GCP_PROJECT="$1"
  [[ -z "${_GCP_PROJECT}" ]] && return 1
  gcloud config set project "${_GCP_PROJECT}"
}

gcloud-net-list(){
  local G_PROJECT="$1"
  [[ -z "${G_PROJECT}" ]] && echo "[err] usage: gcloud-net-list <project>" && return 1
  gcloud --project vault-007 compute networks list
  gcloud --project vault-007 compute networks subnets list
}

gcloud-lbs(){
  local G_PROJECT="$1"
  [[ -z "${G_PROJECT}" ]] && echo "[err] usage: gcloud-lbs <project>" && return 1
  gcloud --project=${G_PROJECT} compute forwarding-rules list
}

gcloud-permit-svc-for-gcr(){
  [[ $# -ne 2 ]] && echo "usage: gcloud-permit-svc-for-gcr <bucket-uri> <svc-account>" && exit 123
  local BUCKET_NAME="$1"
  local SVC_ACCOUNT="$2"
  gsutil -m defacl ch -u $SVC_ACCOUNT:R gs://$BUCKET_NAME
  gsutil -m acl ch -u $SVC_ACCOUNT:R -r gs://$BUCKET_NAME
}
