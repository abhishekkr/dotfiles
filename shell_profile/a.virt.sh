#!/bin/bash

### lxc #######################################################################
alias lxc-ls-lah="sudo lxc-ls -f --nesting -F name,state,interfaces,ipv4,ipv6,autostart,pid,memory,ram,swap,groups"
alias lxc-ls-running="sudo lxc-ls -f --nesting -F name,state,interfaces,ipv4,ipv6,autostart,pid,memory,ram,swap,groups --running"
alias lxc-ls-frozen="sudo lxc-ls -f --nesting -F name,state,interfaces,ipv4,ipv6,autostart,pid,memory,ram,swap,groups --frozen"
alias lxc-ls-active="sudo lxc-ls -f --nesting -F name,state,interfaces,ipv4,ipv6,autostart,pid,memory,ram,swap,groups --active"
alias lxc-ls-stopped="sudo lxc-ls -f --nesting --stopped"
alias lxc-ls-templates="ls -1 /usr/share/lxc/templates/ | sed 's/lxc-/+ /'"

lxc-start-and-console(){
  local _LXC_NAME="$1"
  local _LXC_LOG_FILE="/tmp/lxc.${_LXC_NAME}.log"
  truncate -s 0 "$_LXC_LOG_FILE"
  sudo lxc-start -n ${_LXC_NAME} --logfile=${_LXC_LOG_FILE} --logpriority=DEBUG && sudo lxc-console -n ${_LXC_NAME}
}

lxc-create-from-config(){
  local _LXC_CONFIG="$1"
  local _LXC_NAME=$(grep 'container-name:' "$_LXC_CONFIG" | cut -d' ' -f3)
  local _LXC_TYPE=$(grep 'container-template:' "$_LXC_CONFIG" | cut -d' ' -f3)
  sudo lxc-create -f "$_LXC_CONFIG" -n "$_LXC_NAME" -t "$_LXC_TYPE"
}

lxc-stop-destroy(){
  if [ $# -ne 1 ]; then
    echo "Syntax: lxc-stop-destroy <name-of-spawned-instance-to-destroy>"
    return
  else
    _CONTAINER=$1
  fi
  sudo lxc-stop --name $_CONTAINER && sudo lxc-destroy --name $_CONTAINER
}

lxc-up(){
  if [ $# -ne 1 ]; then
    echo "Syntax: lxc-up <name-of-spawned-instance-to-start>"
    return
  else
    _CONTAINER=$1
  fi
  sudo lxc-start -n $_CONTAINER -d -o "/container/${_CONTAINER}/${_CONTAINER}.log"
}

#
lxc-cmd(){
  if [ $# -ne 1 ]; then
    echo "Syntax: lxc-cmd <name-of-spawned-instance-to-start>"
    return
  else
    _CONTAINER=$1
  fi
  echo "once in lxc console, to quit... run: CTRL+D CTRL+A Q"
  sudo lxc-console -n $_CONTAINER
}

### lxc #end###################################################################


### kube ######################################################################
### pods
k8s-pods(){
  local POD_NAME="$1"
  kubectl get pods ${POD_NAME}
}

k8s-logs(){
  kubectl get po | grep "$1" | awk '{print $1}' | xargs -I{} kubectl logs {}
}

### stateful
k8s-pvc(){
  local PERSISTENT_VOLUME_CLAIM="$1"
  kubectl get pvc ${PERSISTENT_VOLUME_CLAIM}
}

### deployment
k8s-dep(){
  local DEPLOYMENT="$1"
  kubectl get deployments ${DEPLOYMENT}
}

k8s-dep-logs(){
  local DEPLOYMENT="$1"
  local SINCE="$2"
  [[ -z "${SINCE}" ]] && SINCE="30s"
  kubectl logs --since=${SINCE} deployments/${DEPLOYMENT}
}

### service
k8s-svc(){
  local SERVICE="$1"
  kubectl get services ${SERVICE}
}

### jobs
k8s-jobs(){
  local JOB_NAME="$1"
  kubectl get jobs ${JOB_NAME}
}

k8s-jobs-logs(){
  local JOB_NAME="$1"
  kubectl logs "jobs/${JOB_NAME}"
}

k8s-jobs-desc(){
  local JOB_NAME="$1"
  kubectl describe "jobs/${JOB_NAME}"
}

k8s-jobs-pods(){
  local JOB_NAME="$1"
  kubectl get pods --show-all --selector=job-name="${JOB_NAME}" --output=jsonpath={.items..metadata.name}
}

### kube #end##################################################################

### vagrant ###################################################################
alias vagrant-on="vagrant up && vagrant ssh"
alias vagrant-recreate="vagrant destroy --force && vagrant up"
alias vargant-update="vagrant reload --provision"

### vagrant #end###############################################################

### systemd ###################################################################
nspawn-ls(){
  echo "List of all nspawn instances..."
  echo "Archlinux:"
  for itm in `sudo ls "/srv/subarch/"`; do
    echo $itm
  done
  echo "********************"
}

#
nspawn-start(){
  if [ $# -ne 1 ]; then
    echo "Syntax: nspawn-start <name-of-spawned-instance-to-start>"
    return
  fi
  sudo systemctl start machine-${1}
  sudo systemctl start machine-${1}.scope
  sudo systemd-nspawn -bD "/srv/subarch/${1}"
}

nspawn-stop(){
  if [ $# -ne 1 ]; then
    echo "Syntax: nspawn-stop <name-of-spawned-instance-to-stop>"
    return
  fi
  sudo systemctl stop machine-${1}.scope
}

nspawn-del(){
  if [ $# -ne 1 ]; then
    echo "Syntax: nspawn-del <name-of-spawned-instance-to-stop>"
    return
  fi

  _SUB_WORK_DIR="/srv/subarch/${1}"
  if [ ! -d $_SUB_WORK_DIR ]; then
    echo "given vm wasn't found in system slices at sys/fs"
    return
  fi

  sudo systemctl stop machine-${1}.scope
  sudo systemctl disable machine-${1}.scope
  sudo systemctl disable machine-${1}

  sudo rm -rf /sys/fs/cgroup/systemd/system.slice/machine-${1}.scope
  sudo rm -rf /run/systemd/system/machine-${1}.scope.d
  sudo rm -f /run/systemd/system/machine-${1}.scope
  echo "can now delete ${_SUB_WORK_DIR} dir"
}

nspawn-arch(){
  NSPAWN_CACHE="$HOME/.nspawn-cache"
  NSPAWN_CACHE_CHILD="${NSPAWN_CACHE}/srv/subarch/child01"
  mkdir -p $NSPAWN_CACHE
  cd $NSPAWN_CACHE
  if [ ! -d $NSPAWN_CACHE_CHILD ]; then
    curl -kLO https://googledrive.com/host/0B86nn-kptoWCWU9GdzUzWm9aTWs/arch.systemd-nspawn.tar.bz2
    tar jxvf arch.systemd-nspawn.tar.bz2
  fi

  echo "\n\nCopying extracted SubArch files over to require directory..."
  echo "\nWhen it asks for Username at log-in, just say 'root' or try your a/c.\n\n"
  sudo mkdir -p "/srv/subarch/"
  child_count=`ls -1l /srv/subarch/ | grep '^d' | wc -l`
  NSPAWN_NEW_CHILD="/srv/subarch/child${child_count}"

  sudo cp -ar $NSPAWN_CACHE_CHILD $NSPAWN_NEW_CHILD
  echo "done.\n\nLogging in..."
  sudo systemd-nspawn -bD $NSPAWN_NEW_CHILD
}

### systemd #end###############################################################

### podman #start###############################################################
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
### podman #end###############################################################
