#! /bin/bash

virt-svc(){
  local _PODMAN_IMAGE="${1}"
  local _PODMAN_ENTRYPOINT="${2}"
  local _PODMAN_PARAMS="${@:3}"

  podman run -it \
    ${_PODMAN_PARAMS} \
    ${_PODMAN_IMAGE} \
    ${_PODMAN_ENTRYPOINT}
}

virt-alpine(){
  [[ ! -d "/tmp/today" ]] && mkdir /tmp/today
  virt-svc "docker.io/library/alpine:latest" "/bin/sh" "-v /tmp/today:/opt/app:Z"
}

virt-etcd(){
  local _ETCD_ENV_VAR="-e ETCD_NAME=etcd -e ETCD_ADVERTISE_CLIENT_URLS=http://0.0.0.0:2370 -e ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379 -e ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380"
  local _NAME="--name etcd"
  local _EXPOSE_PORT="-p 12379:2379"

  local _IMAGE="quay.io/coreos/etcd"
  local _ENTRYPOINT="/usr/local/bin/etcd"
  local _PARAMS="${_NAME} ${_ETCD_ENV_VAR} ${_EXPOSE_PORT}"

  virt-svc "${_IMAGE}" "${_ENTRYPOINT}" "${_PARAMS}"
   
}

podman-pgsql(){
  local PG_DB="$1"
  local PG_USER="$2"
  local PG_PASSWORD="$3"
  [[ -z "${PG_DB}" ]] && PG_DB=$( head /dev/urandom | tr -dc a-z0-9 | head -c10 )
  [[ -z "${PG_USER}" ]] && PG_USER="postgres"
  [[ -z "${PG_PASSWORD}" ]] && PG_PASSWORD="${PG_USER}"

  mkdir -p "/tmp/${PG_DB}"
  podman run \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_DB=${PG_DB} \
    -v /tmp/${PG_DB}:/var/lib/postgresql/data:Z \
    postgres:12.2-alpine \
    -d "postgres_${PG_DB}"
}
