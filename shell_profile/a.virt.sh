#!/bin/bash

### lxc# ######################################################################
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


### docker# ###################################################################
alias dckr-svr="sudo docker daemon"
alias dckr-svr-sock="sudo chown ${USER}:docker /var/run/docker.sock"
alias dckr-ps="docker ps -a | less -S"
alias dckr-last-container-running="docker inspect --format '{{.State.Running}}' $(docker ps -lq)"
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
dckr-sh(){
  _IMG=$1
  docker run -i -t "${_IMG}" /bin/bash
}
dckr-img-grep(){
  docker images | grep "$@"
}

### from: github.com/jfrazelle [start]
dckr-cleanup(){
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
dckr-del-stopped(){
  local name=$1
  local state=$(docker inspect --format "{{.State.Running}}" $name 2>/dev/null)

  if [[ "$state" == "false"  ]]; then
    docker rm $name
  fi

}
### from: github.com/jfrazelle [end]

### vagrant ###################################################################
alias vagrant-on="vagrant up && vagrant ssh"
alias vagrant-recreate="vagrant destroy --force && vagrant up"
alias vargant-update="vagrant reload --provision"

### lxc #######################################################################
lxc-stop-destroy(){
  if [ $# -ne 1 ]; then
    echo "Syntax: lxc-stop-destroy <name-of-spawned-instance-to-destroy>"
    return
  else
    _CONTAINER=$1
  fi
  lxc-stop -n $_CONTAINER && lxc-destroy $_CONTAINER
}

lxc-up(){
  if [ $# -ne 1 ]; then
    echo "Syntax: lxc-up <name-of-spawned-instance-to-start>"
    return
  else
    _CONTAINER=$1
  fi
  lxc-start -n $_CONTAINER -d -o "/container/${_CONTAINER}/${_CONTAINER}.log"
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
  lxc-console -n $_CONTAINER
}

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
