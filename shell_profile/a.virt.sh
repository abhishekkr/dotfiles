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

### docker ####################################################################
export DOCKER_SOCK="/var/run/docker.sock"
export DOCKER_USER=$(ls -lah ${DOCKER_SOCK} | awk '{print $3}')
export DOCKER_GROUP=$(ls -lah $DOCKER_SOCK | awk '{print $4}')
alias dckr-svr="sudo docker daemon"
alias dckr-svr-sock="sudo chown ${USER}:${DOCKER_GROUP} /var/run/docker.sock"
alias dckr-ps="docker ps -a | less -S"
alias dckr-pull="docker pull"
alias dckr-img="docker images"
alias dckr-latest="docker ps -l -q"
alias dckr-stop="docker stop"
alias dckr-stop-all="docker ps -q | xargs docker stop"
alias dckr-start="docker start"
alias dckr-restart="docker restart"
alias dckr-attach="docker attach"
alias dckr-search="docker search"
#alias dckr-latest-stop="dckr-stop `dckr-latest`"
#alias dckr-latest-start="dckr-start `dckr-latest`"
#alias dckr-latest-restart="dckr-restart `dckr-latest`"
#alias dckr-latest-attach="dckr-attach `dckr-latest`"
alias dckr-selinux-volume="chcon -Rt svirt_sandbox_file_t"
alias dckr-scrub='docker rmi $(docker images -q -f "dangling=true")'

dckr-last-container-running(){
  echo docker inspect --format '{{.State.Running}}' $(docker ps -lq)
}

dckr-vol-cleanup(){
  docker volume ls -qf dangling=true | xargs -r docker volume rm
}
dckr-sh(){
  _IMG=$1
  docker run -i -t "${_IMG}" /bin/bash
}
dckr-sh-limit1(){
  _IMG=$1
  docker run \
    --cpus=".25" --memory=32m --kernel-memory=32m  \
    -p8888:80 -v $PWD:/opt/abk -it \
    "${_IMG}" /bin/bash
}
dckr-sh-limit2(){
  _IMG=$1
  docker run \
    --cpus=".5" --memory=256m --kernel-memory=256m  \
    -p8888:80 -v $PWD:/opt/abk -it \
    "${_IMG}" /bin/bash
}
dckr-img-grep(){
  docker images | grep "$@"
}

### from: github.com/jfrazelle [start]
su-dckr-cleanup(){
  sudo docker rm -v $(sudo docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  sudo docker rmi $(sudo docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
dckr-cleanup(){
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
dckr-del-stopped(){
  local dckrNames=$1
  if [[ -z "${dckrNames}" ]]; then
    dckrNames=$(docker ps -aq)
  fi

  for name in $dckrNames; do
    echo "deleting ${name}"
    local state=$(docker inspect --format "{{.State.Running}}" $name 2>/dev/null)

    if [[ "$state" == "false"  ]]; then
      docker rm $name
    fi
  done
}
dckr-run-mount(){
  [[ $# -lt 2 ]] && \
    echo "[ERROR] Usage: dckr-run-mount HOST_PATH " && \
    return 1
  local _HOST_VOL_PATH="$1"
  local _DOCKER_VOL_PATH="$2"
  local _DOCKER_IMAGE="$3"
  local _DOCKER_CMD="$4"
  docker run -i -t -v ${_HOST_VOL_PATH}:${_DOCKER_VOL_PATH} $_DOCKER_IMAGE $_DOCKER_CMD
}

dckr-ip-of(){
  local DOCKER_SEARCH_TERM="$@"
  docker ps | grep "${DOCKER_SEARCH_TERM}" | awk '{print $1}' | xargs -I{} docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'  {}
}

dckr-del-grep(){
  docker ps -a | grep "${1}"  | awk '{print $3}' | xargs -I{} docker rm {}
}
dckr-del-day-old(){
  docker ps -a | grep -v -E 'hours|minutes|seconds' | awk '{print $1}' | xargs -I{} docker rm {}
}
dckr-last-log(){
  docker logs $(docker ps -ql)
}

### from: github.com/jfrazelle [end]

### docker #end################################################################

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
