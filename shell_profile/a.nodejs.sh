
export NVM_DIR="$HOME/.nvm"
if [[ -d "${NVM_DIR}" ]]; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


nvm-update(){
  pushd "$NVM_DIR"
  git fetch --tags origin

  local GIT_REVLIST=$(git rev-list --tags --max-count=1)
  local GIT_BRANCH=`git describe --abbrev=0 --tags --match "v[0-9]*" ${GIT_REVLIST}`
  git checkout ${GIT_BRANCH} && source "$NVM_DIR/nvm.sh"
}

nvm-install(){
  local VERSION=${1:-node}
  nvm install $VERSION
  nvm use $VERSION
}
