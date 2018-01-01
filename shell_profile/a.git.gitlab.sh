
gitlab-pipeline(){
  local _GITLAB_PROJECT_ID="$1"
  local _GITLAB_PIPELINE_ID="$2"

  [[ -z "${GITLAB_PRIVATE_TOKEN}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1
  [[ -z "${_GITLAB_PROJECT_ID}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1

  curl -skL --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "https://source.golabs.io/api/v4/projects/${_GITLAB_PROJECT_ID}/pipelines/${_GITLAB_DEPLOYMENT_ID}" | jq "."
}

gitlab-pipelines(){
  local _GITLAB_PROJECT_ID="$1"

  [[ -z "${GITLAB_PRIVATE_TOKEN}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1
  [[ -z "${_GITLAB_PROJECT_ID}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1

  curl -skL --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "https://source.golabs.io/api/v4/projects/${_GITLAB_PROJECT_ID}/pipelines" | jq "."
}

gitlab-deployment(){
  local _GITLAB_PROJECT_ID="$1"
  local _GITLAB_DEPLOYMENT_ID="$2"

  [[ -z "${GITLAB_PRIVATE_TOKEN}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1
  [[ -z "${_GITLAB_PROJECT_ID}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1

  curl -skL --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "https://source.golabs.io/api/v4/projects/${_GITLAB_PROJECT_ID}/deployments/${_GITLAB_DEPLOYMENT_ID}" | jq "."
}

gitlab-deployments(){
  local _GITLAB_PROJECT_ID="$1"

  [[ -z "${GITLAB_PRIVATE_TOKEN}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1
  [[ -z "${_GITLAB_PROJECT_ID}" ]] && echo "env GITLAB_PRIVATE_TOKEN missing" && return 1

  curl -skL --header "PRIVATE-TOKEN: ${GITLAB_PRIVATE_TOKEN}" "https://source.golabs.io/api/v4/projects/${_GITLAB_PROJECT_ID}/deployments" | jq "."
}
