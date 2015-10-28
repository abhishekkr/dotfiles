#!/bin/bash

if [ -z $REPO_ROOT ]; then
  REPO_ROOT=$(dirname $(dirname $0))
  cd $REPO_ROOT
  REPO_ROOT=${PWD}
  cd -
fi

## 'link all $HOME/.*rc'
rc_setup(){
  mkdir -p "${HOME}"

  for RCFilePath in `ls $REPO_ROOT/rc/[a-zA-Z]?*`; do
    RCFilename=$(basename $RCFilePath)
    destination="$HOME/.${RCFilename}"
    if [[ -f "$destination" ]]; then
      if [[ ! -L "$destination" ]]; then
        echo "[ERROR:] ${destination} is a file, remove and re-run if wanna override!"
        continue
      fi
      echo "${destination} link already exists."
      continue
    fi
    ln -sf "${RCFilePath}" "${destination}"
    if [[ ! -L "$destination" ]]; then
      echo "${destination} copy failed."
      continue
    fi
  done
}

rc_setup
