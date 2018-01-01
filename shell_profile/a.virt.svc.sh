

virt-svc(){
  local _DOCKER_IMAGE="${1}"
  local _DOCKER_ENTRYPOINT="${2}"
  local _DOCKER_PARAMS="${3}"
  echo docker run ${_DOCKER_PARAMS} -i -t ${_DOCKER_IMAGE} ${_DOCKER_ENTRYPOINT}
}

virt-etcd(){
  local _DOCKER_ETCD_ENV_VAR="-e ETCD_NAME=etcd -e ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2370 -e ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379 -e ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380"
  local _DOCKER_NAME="--name etcd"
  local _DOCKER_EXPOSE_PORT="-p 12379:2379"
  local _DOCKER_PARAMS="${_DOCKER_NAME} ${_DOCKER_ETCD_ENV_VAR} ${_DOCKER_EXPOSE_PORT}"

  local _DOCKER_IMAGE="quay.io/coreos/etcd"
  local _DOCKER_ENTRYPOINT="/usr/local/bin/etcd"

  virt-svc "${_DOCKER_IMAGE}" "${_DOCKER_ENTRYPOINT}" "${_DOCKER_PARAMS}"
   
}
