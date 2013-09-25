# .bashrc

alias py='/usr/bin/env python2'
alias server.py='python2 -m SimpleHTTPServer'

# let's you re-use pip downoads between branches
export PIP_DOWNLOAD_CACHE=$HOME/cache/pip

alias pyibook='ipython2 notebook'

venv_on(){
  [ ! -s ./.venv ] && virtualenv .venv
  source .venv/bin/activate
}

alias venv_off="deactivate"
