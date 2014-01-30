# .bashrc

alias py='/usr/bin/env python2'
alias server.py='python2 -m SimpleHTTPServer'

# let's you re-use pip downoads between branches
export PIP_DOWNLOAD_CACHE=$HOME/cache/pip

alias pydoc8080="pydoc2 -p 8080"

alias pyibook='ipython2 notebook'

venv_on(){
  [ ! -s ./.venv ] && virtualenv2 .venv
  source .venv/bin/activate
}
alias venv2_on="venv_on"
venv3_on(){
  [ ! -s ./.venv ] && virtualenv3 .venv
  source .venv/bin/activate
}

alias venv_off="deactivate"

alias py-profile="time python -m cProfile"

venv_anon(){
  if [ ! -d $HOME/.virtualenvs ]; then
    mkdir -p $HOME/.virtualenvs
  fi
  [ ! -s $HOME/.virtualenvs/anon ] && virtualenv2 $HOME/.virtualenvs/anon
  source $HOME/.virtualenvs/anon/bin/activate
}
