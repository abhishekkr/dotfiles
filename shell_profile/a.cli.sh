# profile for cli

c32x32(){
  convert -scale 600x400 $1 $2
}
c60x60(){
  convert -scale 600x400 $1 $2
}
c120x120(){
  convert -scale 600x400 $1 $2
}
c300x200(){
  convert -scale 600x400 $1 $2
}
c600x400(){
  convert -scale 600x400 $1 $2
}
c800x600(){
  convert -scale 800x600 $1 $2
}
c1024x768(){
  convert -scale 1024x768 $1 $2
}

lswp(){
  ls -lahR $1 | grep '.swp$'
}
du_gb(){
  sudo du --exclude='/proc' --exclude='/dev' --exclude='/media' -h $@ | grep [0-9.\s][0-9]G
}
du_mb(){
  sudo du --exclude='/proc' --exclude='/dev' --exclude='/media' -h $@ | grep [0-9.\s][0-9]M
}
surl(){
  if [ $# -eq 1 ];
  then
    curl -L -s --head "$@" | grep 'Content-Length' | awk -F ':' '{a=($2/1024)/1024; print a" MB"}'
  else
    echo '$ surl <url> ### tells you filesize of URLs content in MB'
  fi
}
wurl(){
  if [ $# -eq 2 ];
  then
    curl -L -o $1 $2
  else
    echo '$ wurl <saveAsFile> <url> ### downloads url as saveAsFile'
  fi
}
wddl(){
  if [ $# -eq 2 ];
  then
    wget -c -O $1 $2
  else
    echo '$ wddl <saveAsFile> <url> ### downloads url as saveAsFile'
  fi
}
mdcd(){
  mkdir -p $@ ; cd $@
}
anet(){
  echo $@ | awk '{ system("google-chrome \""$0"\" 2> /dev/null"); }'
}
alook(){
  echo $@ | awk '{ system("google-chrome \"? "$0"\" 2> /dev/null"); }'
}
psgrep(){
  ps aux | grep "$@" | grep -v grep
}
pidgrep(){
  ps aux | grep "$@" | grep -v grep
}
killgrep(){
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

# don't delete root and prompt if deleting more than 3 files at a time
alias rm='rm -I --preserve-root'
# Parenting changing perms on /
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias duh='du -h --max-depth=1'

alias lsz='ls -sh'
alias lsz1='ls -sh1'
alias la='ls -lash'

alias items='ls -1 | wc -l'
alias mysize='du -h | grep -e "\.$" | cut -f1'

alias ipaddr="ifconfig | grep 'inet ' | awk '{print $2}'"
alias ports='netstat -tulanp'

export PATH=$PATH:$HOME\bin
