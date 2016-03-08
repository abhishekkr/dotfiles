# .bashrc

alias py='/usr/bin/env python2'
alias server.py='python2 -m SimpleHTTPServer'

# let's you re-use pip downoads between branches
export PIP_DOWNLOAD_CACHE=$HOME/cache/pip

alias pydoc8080="pydoc2 -p 8080"

alias pyibook='ipython2 notebook'

alias py-profile="time python -m cProfile"

venv_on_for(){
  local VENV_PATH="$1"
  [ ! -s "${VENV_PATH}" ] && virtualenv2 "${VENV_PATH}"
  source "${VENV_PATH}/bin/activate"
  export _TMP_VENV_PATH="${PATH}"
  export PATH="${VENV_PATH}/bin:${PATH}"
}

venv_on(){
  local VENV_PATH="${PWD}/.venv"
  venv_on_for "${VENV_PATH}"
}
alias venv2_on="venv_on"
venv3_on(){
  [ ! -s ./.venv ] && virtualenv3 .venv
  source .venv/bin/activate
  _TMP_VENV_PATH=$PATH
  PATH=$PATH:$PWD/.venv/bin
}

venv_off(){
  deactivate
  if [[ ! -z $_TMP_VENV_PATH ]]; then
    PATH=${_TMP_VENV_PATH}
  fi
}

venv_anon(){
  HOME_VIRTUALENV="${HOME}/.virtualenvs"
  ANON_VIRTUALENV="${HOME_VIRTUALENV}/anon"
  if [ ! -d ${HOME_VIRTUALENV} ]; then
    mkdir -p ${HOME_VIRTUALENV}
  fi
  [ ! -s ${ANON_VIRTUALENV} ] && virtualenv2 ${ANON_VIRTUALENV}
  source ${ANON_VIRTUALENV}/bin/activate
  export _TMP_VENV_PATH=$PATH
  export PATH=${ANON_VIRTUALENV}/bin:$PATH
}

