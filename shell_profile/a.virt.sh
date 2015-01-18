#!/bin/bash

### docker# ###################################################################
alias dckr-svr="sudo docker -d"
alias dckr-ps="docker ps -a | less -S"
alias dckr-last-container-running="docker inspect --format '{{.State.Running}}' $(docker ps -lq)"
alias dckr-pull="docker pull"
alias dckr-latest="docker ps -l -q"
alias dckr-stop="docker stop"
alias dckr-start="docker start"
alias dckr-restart="docker restart"
alias dckr-attach="docker attach"
#alias dckr-latest-stop="dckr-stop `dckr-latest`"
#alias dckr-latest-start="dckr-start `dckr-latest`"
#alias dckr-latest-restart="dckr-restart `dckr-latest`"
#alias dckr-latest-attach="dckr-attach `dckr-latest`"

### vagrant ###################################################################
alias vagrant-on="vagrant up && vagrant ssh"

### lxc #######################################################################
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

nspawn-start(){
  if [ $# -ne 1 ]; then
    echo "Syntax: nspawn-start <name-of-spawned-instance-to-start>"
    return
  fi
  sudo systemd-nspawn -bD "/srv/subarch/${1}"
}

nspawn-stop(){
  if [ $# -ne 1 ]; then
    echo "Syntax: nspawn-stop <name-of-spawned-instance-to-stop>"
    return
  fi
  sudo systemctl stop machine-${1}.scope
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
