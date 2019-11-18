#!/bin/bash

if [ -z $REPO_ROOT ]; then
  REPO_ROOT=$(dirname $(dirname $0))
  cd $REPO_ROOT
  REPO_ROOT=${PWD}
  cd -
fi

## link RCFilePath to destination
link_rc(){
  [[ $# -ne 2 ]] && echo "usage: link_rc <rc-filename> <destination>" && exit 0
  local RCFilename="$1"
  local destination="$2"

  if [[ -f "$destination" ]]; then
    if [[ ! -L "$destination" ]]; then
      echo "[ERROR:] ${destination} is a file, remove and re-run if wanna override!"
      return 1
    fi
    echo "${destination} link already exists."
    return 0
  fi
  ln -sf "${RCFilePath}" "${destination}"
  if [[ ! -L "$destination" ]]; then
    echo "${destination} copy failed."
    return 1
  fi
}

## 'link all $HOME/.*rc'
rc_setup(){
  mkdir -p "${HOME}"

  for RCFilePath in `ls $REPO_ROOT/rc/[a-zA-Z]?*`; do
    RCFilename=$(basename $RCFilePath)
    destination="$HOME/.${RCFilename}"

    link_rc "${RCFilePath}" "${destination}"
  done
}

specific_rc(){
  link_rc "${REPO_ROOT}/rc/iex.exs" "${HOME}/.iex.exs"
}

rc_setup
specific_rc
