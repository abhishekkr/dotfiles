#!/bin/bash

_action="all"
if [[ $# -ne 0 ]]; then
  _action=$1
fi

if [ -z "${REPO_ROOT}" ]; then
  REPO_ROOT=$(dirname $0)
  cd "${REPO_ROOT}"
  REPO_ROOT="${PWD}"
  cd -
fi

case $_action in
  "all")
    echo "***********************************************[ Setup Everything ]***"
    for task in "rc" "profile" "vim" "bin" "extra"; do
      $0 $task
    done
    echo "**********************************************************************"
  ;;
  "profile")
    echo "***********************************************[ Setup Profile ]******"
    bash tasks/profile.sh
    echo "**********************************************************************"
  ;;
  "rc")
    echo "***********************************************[ Setup RC-Config ]****"
    bash tasks/rc.sh
    echo "**********************************************************************"
  ;;
  "vim")
    echo "***********************************************[ Setup Vim ]**********"
    bash tasks/vim.sh
    echo "**********************************************************************"
  ;;
  "bin")
    echo "***********************************************[ Setup Binaries ]*****"
    bash tasks/bin.sh
    echo "**********************************************************************"
  ;;
  "extra")
    echo "***********************************************[ Setup Binaries ]*****"
    bash tasks/extra.sh
    echo "**********************************************************************"
  ;;
  *)
    echo "***********************************************[ HELP ]***************"
    echo " To set-up everything following, run       ' ./setup.sh '"
    echo " To set-up /etc/profile.d/<profiles>, run  ' ./setup.sh profile '"
    echo " To set-up RC Scripts, run                 ' ./setup.sh rc '"
    echo " To set-up \$HOME/.vim, run                ' ./setup.sh vim '"
    echo " To set-up binaries at \$HOME/bin, run     ' ./setup.sh bin '"
    echo " To set-up extras (zsh-plugin)             ' ./setup.sh extra '"
    echo "**********************************************************************"
  ;;
esac
exit

unset _action

