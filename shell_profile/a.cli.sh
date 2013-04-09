# profile for cli

function c32x32(){
  convert -scale 600x400 $1 $2
}
function c60x60(){
  convert -scale 600x400 $1 $2
}
function c120x120(){
  convert -scale 600x400 $1 $2
}
function c300x200(){
  convert -scale 600x400 $1 $2
}
function c600x400(){
  convert -scale 600x400 $1 $2
}
function c800x600(){
  convert -scale 800x600 $1 $2
}
function c1024x768(){
  convert -scale 1024x768 $1 $2
}

function lswp(){
  ls -lahR $1 | grep '.swp$'
}
function du-gb(){
  sudo du --exclude='/proc' --exclude='/dev' --exclude='/media' -h $@ | grep [0-9.\s][0-9]G
}
function du-mb(){
  sudo du --exclude='/proc' --exclude='/dev' --exclude='/media' -h $@ | grep [0-9.\s][0-9]M
}
function surl(){
  if [ $# -eq 1 ];
  then
    curl -L -s --head "$@" | grep 'Content-Length' | awk -F ':' '{a=($2/1024)/1024; print a" MB"}'
  else
    echo '$ surl <url> ### tells you filesize of URLs content in MB'
  fi
}
function wurl(){
  if [ $# -eq 2 ];
  then
    curl -L -o $1 $2
  else
    echo '$ wurl <saveAsFile> <url> ### downloads url as saveAsFile'
  fi
}
function wddl(){
  if [ $# -eq 2 ];
  then
    wget -c -O $1 $2
  else
    echo '$ wddl <saveAsFile> <url> ### downloads url as saveAsFile'
  fi
}
function mdcd(){
  mkdir -p $@ ; cd $@
}
function anet(){
  echo $@ | awk '{ system("google-chrome \""$0"\" 2> /dev/null"); }'
}
function alook(){
  echo $@ | awk '{ system("google-chrome \"? "$0"\" 2> /dev/null"); }'
}
function psgrep(){
  ps aux | grep "$@" | grep -v grep
}
function pidgrep(){
  ps aux | grep "$@" | grep -v grep
}
function killgrep(){
  if [ $# -eq 1 ];
  then
    echo 'killing:'
    ps aux | grep "$@" | grep -v grep
    ps aux | grep "$@" | grep -v grep | awk '{system("kill -9 "$2"")}'
  else
    echo '$ killgrep <pattern> ### killing the "ps aux" based on pattern'
  fi
}

alias grep='grep --color'

alias duh='du -h --max-depth=1'

alias lsz='ls -sh'
alias lsz1='ls -sh1'
alias la='ls -lash'
