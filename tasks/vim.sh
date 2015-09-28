#!/bin/bash

if [ -z $REPO_ROOT ]; then
  REPO_ROOT=$(dirname $(dirname $0))
  cd $REPO_ROOT
  REPO_ROOT=${PWD}
  cd -
fi

setup_gvimrc(){
  ln -sf "${REPO_ROOT}/rc/vimrc" "${HOME}/.gvimrc"
}

setup_vim_profile(){
  ln -sf "${REPO_ROOT}/vim" "${HOME}/.vim"
}

setup_vim_bundle(){
  echo "Sync up all Vim add-ons {pathogen,}"
  vim_bundle="${REPO_ROOT}/vim/bundle"
  mkdir -p "$vim_bundle"
  tasks_shell_path="$REPO_ROOT/tasks/shell"
  bash "${tasks_shell_path}/vim-pathogen-plugin-sync.sh"
}

setup_gvimrc
setup_vim_profile
setup_vim_bundle
