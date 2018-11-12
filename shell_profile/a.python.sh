# .bashrc

alias py2='/usr/bin/env python2'
alias py3='/usr/bin/env python3'
alias py='py3'
alias server.py='python2 -m SimpleHTTPServer'

# let's you re-use pip downoads between branches
export PIP_DOWNLOAD_CACHE=$HOME/cache/pip

alias pydoc8080="pydoc2 -p 8080"

alias pyibook='ipython2 notebook'

alias py-profile="time python -m cProfile"

[[ "$(which virtualenv2 &> /dev/null ; echo $?)" -ne 0  ]] && alias virtualenv2="virtualenv --python=python2"

[[ "$(which virtualenv3 &> /dev/null ; echo $?)" -ne 0  ]] && alias virtualenv3="virtualenv --python=python3"


venv2_on_for(){
  local VENV_PATH="$1"
  [ ! -s "${VENV_PATH}" ] && virtualenv2 "${VENV_PATH}"
  source "${VENV_PATH}/bin/activate"
  export _TMP_VENV_PATH="${PATH}"
  export PATH="${VENV_PATH}/bin:${PATH}"
}

venv3_on_for(){
  local VENV_PATH="$1"
  [ ! -s "${VENV_PATH}" ] && virtualenv3 "${VENV_PATH}"
  source "${VENV_PATH}/bin/activate"
  export _TMP_VENV_PATH="${PATH}"
  export PATH="${VENV_PATH}/bin:${PATH}"
}

alias venv_on_for=venv3_on_for

venv2_on(){
  local VENV_PATH="${PWD}/.venv"
  venv_on_for "${VENV_PATH}"
}

venv3_on(){
  local VENV_PATH="${PWD}/.venv"
  venv_on_for "${VENV_PATH}"
}

alias venv_on="venv3_on"

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
  [ ! -s ${ANON_VIRTUALENV} ] && virtualenv3 ${ANON_VIRTUALENV}
  source ${ANON_VIRTUALENV}/bin/activate
  export _TMP_VENV_PATH=$PATH
  export PATH=${ANON_VIRTUALENV}/bin:$PATH
}

decimalToBinary(){
  local _DEC=$1
  [[ -z "${_DEC}" ]] && return 123
  python -c "print(bin("${_DEC}"))"
}

binaryToDecimal(){
  local _BIN=$1
  [[ -z "${_BIN}" ]] && return 123
  python -c "print(int('"${_BIN}"', 2))"
}
