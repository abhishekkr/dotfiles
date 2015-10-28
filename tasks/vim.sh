#!/bin/bash

if [ -z $REPO_ROOT ]; then
  REPO_ROOT=$(dirname $(dirname $0))
  cd $REPO_ROOT
  REPO_ROOT=${PWD}
  cd -
fi

setup_gvimrc(){
  if [[ ! -L "${HOME}/.gvimrc" ]]; then
    if [[ -f "${HOME}/.gvimrc" ]]; then
      echo "~/.gvimrc is a file, remove and re-run to override"
      return
    fi
    ln -sf "${REPO_ROOT}/rc/vimrc" "${HOME}/.gvimrc"
  fi
}

setup_vim_bundle(){
  echo "Sync up all Vim add-ons {pathogen,}"
  vim_bundle="${REPO_ROOT}/vim/bundle"
  mkdir -p "$vim_bundle"
  tasks_shell_path="$REPO_ROOT/tasks/shell"
  bash "${tasks_shell_path}/vim-pathogen-plugin-sync.sh"
}

setup_vim_profile(){
  if [[ ! -L "${HOME}/.vim" ]]; then
    if [[ -f "${HOME}/.vim" ]]; then
      echo "~/.vim is a file, remove and re-run to override"
      return
    fi
    if [[ -d "${HOME}/.vim" ]]; then
      echo "~/.vim is a directory, remove and re-run to override"
      return
    fi
    ln -sf "${REPO_ROOT}/vim" "${HOME}/.vim"
  fi
  if [[ -L "${HOME}/.vim" ]]; then
    setup_vim_bundle
  fi
}

setup_gvimrc
setup_vim_profile
