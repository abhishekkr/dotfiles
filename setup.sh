#!/bin/bash

if [ -z $REPO_ROOT ]; then
  REPO_ROOT=$(dirname $0)
  cd $REPO_ROOT
  REPO_ROOT=${PWD}
  cd -
fi

echo "************************************************************************"
echo "[ Setting up PROFILE.d links ]"
bash tasks/profile.sh

echo "************************************************************************"
echo "[ Setting up RC config links ]"
bash tasks/rc.sh

echo "************************************************************************"
echo "[ Setting up VIM Home Config ]"
bash tasks/vim.sh

echo "************************************************************************"
echo "[ Setting up Portable Binaries ]"
bash tasks/bin.sh

echo "************************************************************************"
