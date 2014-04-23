# profile for cli

alias xstart="startxfce4"

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

alias ls1="ls -1"

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

dump-paths(){
  _mountname=$(basename $1)
  find $1 > "${_mountname}.log"
}

alias grep-video="grep -E 'mkv$|avi$|mp4$|wmv$|mov$|ogv$|webm$|mpg$|mpeg$|mov$'"
alias grep-audio="grep -E 'wav$|flac$|mp3$|ogg$'"
alias grep-docs="grep -E 'doc$|odp$|pdf$|txt$|log$|htm$|html$|djvu$|epub$'"

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
alias ls-size="ls -lah | grep '^total'"

alias items='ls -1 | wc -l'
alias mysize='du -h | grep -e "\.$" | cut -f1'

alias ipaddr="ifconfig | grep 'inet ' | awk '{print \$2}'"
alias ports='netstat -tulanp'
alias check-net='ping 8.8.8.8'

alias espeakf="espeak -ven-us+f2"

## remote controller
alias 0ssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias 0scp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'

alias ls-net-svc="netstat -plut"

alias prompt_time='PROMPT="%K%B%t "'
alias prompt_user='PROMPT="${USER}$ "'
alias prompt_user_pwd='PROMPT="${USER}:${$(basename $PWD)}$ "'

alias rsync_to="rsync -lavzh  --exclude .git ./"

alias enable_ip_forwarding="echo 1 > /proc/sys/net/ipv4/ip_forward"

alias drop_cache="echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null"

alias server.https="python -m SimpleHTTPServer & ncat --ssl -l 8443 --sh-exec \"ncat 127.0.0.1 8000\" --keep-open"

alias vim-hor="vim -o"
alias vim-ver="vim -O"

cddev(){
  if [ -z $ABK_DEV_DIR ]; then
    echo "Your Dev dir is not set." ; return 1
  fi
  cd $ABK_DEV_DIR/$1
}


xrandr-auto(){
  IN="LVDS-1"
  EXT="VGA-1"

  if (xrandr | grep "$EXT disconnected"); then
    xrandr --output $IN --auto --output $EXT --off
  else
    xrandr --output $IN --auto --primary --output $EXT --auto --right-of $IN
  fi
}

[ -d $HOME/bin ] && export PATH=$PATH:$HOME/bin
[ -d $HOME/.cabal/bin ] && export PATH=$PATH:$HOME/.cabal/bin


ascii_pacman(){
    if [[ $1 != "" ]]; then
      _msg=$1
    else
      _msg=`date`
    fi
    _asciiart_pacman="__________________|      |____________________________________________";
    _asciiart_pacman=$_asciiart_pacman"\n     ,--.    ,--.          ,--.   ,--.";
    _asciiart_pacman=$_asciiart_pacman"\n    |oo  | _  \  \`.       | oo | |  oo|";
    _asciiart_pacman=$_asciiart_pacman"\no  o|~~  |(_) /   ;       | ~~ | |  ~~|o  o  o  ${_msg} o  o";
    _asciiart_pacman=$_asciiart_pacman"\n    |/\/\|   '._,'        |/\/\| |/\/\|";
    _asciiart_pacman=$_asciiart_pacman"\n__________________        ____________________________________________";
    _asciiart_pacman=$_asciiart_pacman"\n__________________|      |____________________________________________";
    echo "$_asciiart_pacman"
}

ascii_maxpayne(){
    if [[ $1 != "" ]]; then
      _msg=$1
    else
      _msg=`date`
    fi
_asciiart_maxpayne=""
_asciiart_maxpayne=$_asciiart_maxpayne"\n                         ..sSsSSSSSSb.                                       "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                       .SSSSSSSSSSSSSSS.                                     "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                    .SSSSSSSSSSSSSSSSSSSSSb.                                 "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                  .SSSSSSSSSSSSSSSSSSSSSSSSS                                 "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                 SSSSSSSSSSSSSSSSSS\'  \`SSSS                                 "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                 SSSSSSSSSSSSSSS\'        SSS                                 "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                 SSSSSSSSSSSSS\'         \`SS.                                "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                \`SSSSSSSSSSSSS          \`SSS.                              "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                  \`SSSSSSSSS\'       .sSSS SS S                              "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                     SSSSSSSSS.sSs .sSSs\"   s s                              "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                      SSSSSSSSSSSS           SP                              "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                     \`SSSSSSSSSSSs          S                               "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                        SSSSSSSSSSS.    \",                                   "
_asciiart_maxpayne=$_asciiart_maxpayne"\n                       \`SSSSSSSSSSsSS                                       "
_asciiart_maxpayne=$_asciiart_maxpayne"\n        sSSS.           \`SSSSSSSSSSSS.s\"\'   .S.                             "
_asciiart_maxpayne=$_asciiart_maxpayne"\n        SSSSS.             \`SSSSSSSSSS.    .SSSSs.sSs.                      "
_asciiart_maxpayne=$_asciiart_maxpayne"\n         SSSSS.             \`SSSSSSSSSP   .SSSSSSSSSSSS.                    "
_asciiart_maxpayne=$_asciiart_maxpayne"\n         SSSSSS.              \`SSSSSSS\' .SSSSSSSSSSSSSSSS.                  "
_asciiart_maxpayne=$_asciiart_maxpayne"\n         \`SSSSSS.                 SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs.          "
_asciiart_maxpayne=$_asciiart_maxpayne"\n           SSSSSS.               \`SSSSSSSSS SSSSSSSSSSSSSSSSSSSSSSSSs.      "
_asciiart_maxpayne=$_asciiart_maxpayne"\n         .sSSSSSSS.                \`SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS.    "
_asciiart_maxpayne=$_asciiart_maxpayne"\n         s  SSSSSSS.                .SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS.   "
_asciiart_maxpayne=$_asciiart_maxpayne"\n         \`SSSSSSSSSS.             .SSS\' SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS.  "
_asciiart_maxpayne=$_asciiart_maxpayne"\n          \`SSSSSSSSSS.           sS\'   SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS."
_asciiart_maxpayne=$_asciiart_maxpayne"\n          SSSSSSSSSSSSe         SSS     \`SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
_asciiart_maxpayne=$_asciiart_maxpayne"\n        .\' SSSSSSSSSS7         SSSS       \`SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
_asciiart_maxpayne=$_asciiart_maxpayne"\n       \"   \`SSSSSSSS7         SSSSS       .SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
_asciiart_maxpayne=$_asciiart_maxpayne"\n      SSSs..SSSSSSS7        SSSSSSS    .sSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
_asciiart_maxpayne=$_asciiart_maxpayne"\n       SSSSSSSSSSSS        SSSSSSSS .sSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
_asciiart_maxpayne=$_asciiart_maxpayne"\n        SSSSSSSSSSS     .SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
_asciiart_maxpayne=$_asciiart_maxpayne"\n      .SSSSSSSSSSSSS   .SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
_asciiart_maxpayne=$_asciiart_maxpayne"\n      SSSSSSSSSSSSSS  .SSSSSSSSSSS SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
echo $_asciiart_maxpayne
}

cowsay -f dragon "$USER is here..."

arch-font-install(){
  _FONTDIR="/usr/share/fonts/$USER"
  sudo mkdir -p $_FONTDIR
  cp -ar $1 $_FONTDIR
  fc-cache -vf
  unset _FONTDIR
}


set_proxy(){
  if [ $# -ne 1 ]; then
    echo "Wrong Syntax."
    echo "Syntax: $0 <entire-string-to-set-full-url-with-port-user-password>"
    return 1
  fi
  PROXY_ENV="http_proxy ftp_proxy https_proxy rsync_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY NO_PROXY ALL_PROXY"
  for envar in `echo $PROXY_ENV`
  do
    echo $envar
    export $envar=$1
  done
  #export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
  echo -e "Proxy environment variable set."
}

unset_proxy(){
  PROXY_ENV="http_proxy ftp_proxy https_proxy rsync_proxy all_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY NO_PROXY ALL_PROXY"
  for _envar in `echo $PROXY_ENV`
  do
    echo "Unset $_envar"
    unset "$_envar"
  done
  echo -e "Proxy environment variable removed."
}

alias es_start="sudo elasticsearch -p /tmp/elasticsearch.pid"

alias fix-fs-fat="fsck.vfat -favrt"
alias fix-fs-ntfs="ntfsck -favrt"
