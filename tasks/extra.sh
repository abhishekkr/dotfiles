#!/usr/bin/env bash

if [[ -z "$REPO_ROOT" ]]; then
  REPO_ROOT=$(dirname $(dirname $0))
  cd $REPO_ROOT
  REPO_ROOT=${PWD}
  cd -
fi

if [[ -z "$TASKS_SHELL_PATH" ]]; then
  TASKS_SHELL_PATH="$REPO_ROOT/tasks/shell"
fi

zsh_extra(){
  bash "${TASKS_SHELL_PATH}/zsh-extra.sh"
}

# __main__
zsh_extra
