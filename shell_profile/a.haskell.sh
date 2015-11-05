# .bashrc

alias hs='/usr/bin/env ghci'

_CABAL_ENV_=".cabalenv"

cabal_init(){
  cabal sandbox init --sandbox=${_CABAL_ENV_}

  export _TMP_CABAL_ENV_PATH=$PATH
  export PATH=${PWD}/${_CABAL_ENV_}/bin:$PATH
}

cabal_destroy(){
  cabal sandbox delete
  if [[ ! -z $_TMP_CABAL_ENV_PATH ]]; then
    PATH=${_TMP_CABAL_ENV_PATH}
  fi
}

