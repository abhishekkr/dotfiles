#!/bin/bash

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
