# profile for cli

alias ls='ls --color=auto'
alias rdp="rdesktop-vrdp -u administrator -p -"

alias uhoh-scr="xscreensaver-command -lock"
alias uhoh="xlock"

alias ack="ack --ignore-dir=.venv --ignore-dir=.git"

mycd(){
  if [[ $# -eq 1 ]]; then
    cd "$1"
    if [[ -d "$1/.goenv" ]]; then `goenv_on` ; fi
  fi
}

alias xstart="startxfce4"

c32x32(){
  convert -scale 32x32 "$1" "$2"
}
c60x60(){
  convert -scale 60x60 "$1" "$2"
}
c120x120(){
  convert -scale 120x120 "$1" "$2"
}
c300x200(){
  convert -scale 300x200 "$1" "$2"
}
c600x400(){
  convert -scale 600x400 "$1" "$2"
}
c800x600(){
  convert -scale 800x600 "$1" "$2"
}
c1024x768(){
  convert -scale 1024x768 "$1" "$2"
}

alias ls1="ls -1"

lswp(){
  ls -lahR "$1" | grep '.swp$'
}
du_gb(){
  sudo du --exclude='/proc' --exclude='/dev' --exclude='/media' -h "$@" | grep [0-9.\s][0-9]G
}
du_mb(){
  sudo du --exclude='/proc' --exclude='/dev' --exclude='/media' -h "$@" | grep [0-9.\s][0-9]M
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
    curl -L -o "$1" "$2"
  else
    echo '$ wurl <saveAsFile> <url> ### downloads url as saveAsFile'
  fi
}
wddl(){
  if [ $# -eq 2 ];
  then
    wget -c -O "$1" "$2"
  else
    echo '$ wddl <saveAsFile> <url> ### downloads url as saveAsFile'
  fi
}
mdcd(){
  mkdir -p "$@" ; cd "$@"
}
anet(){
  echo "$@" | awk '{ system("google-chrome \""$0"\" 2> /dev/null"); }'
}
alook(){
  echo "$@" | awk '{ system("google-chrome \"? "$0"\" 2> /dev/null"); }'
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
  _mountname=$(basename "$1")
  find "$1" > "${_mountname}.log"
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
alias dfroot="df -h | grep '\s*/$'"

alias lsz='ls -sh'
alias lsz1='ls -sh1'
alias la='ls -lash'
alias ls-size="ls -lah | grep '^total'"

ls-top10files(){
  local _CHECK_THIS_PATH="$1"
  find $_CHECK_THIS_PATH -type f -exec ls -sh {} \; | sort -n -r | head -10
}

alias items='ls -1 | wc -l'
alias mysize='du -h | grep -e "\.$" | cut -f1'

alias ipaddr="ifconfig | grep 'inet ' | awk '{print \$2}'"
alias ports='netstat -tulanp'
alias check-net='ping 8.8.8.8'
alias check-http='curl -LkI www.google.co.in'

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
  if [ -z "$ABK_DEV_DIR" ]; then
    echo "Your Dev dir is not set." ; return 1
  fi
  cd "$ABK_DEV_DIR/$1"
}

alias cddev-local="cddev ../on_local"


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
    if [[ "$1" != "" ]]; then
      _msg="$1"
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
    if [[ "$1" != "" ]]; then
      _msg="$1"
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
  cp -ar "$1" $_FONTDIR
  fc-cache -vf
  unset _FONTDIR
}


set_ssh_proxy(){
  _CORKSCREW_BIN=`which corkscrew`
  if [ ! -x "$_CORKSCREW_BIN" ]; then
    echo "ERROR: Corkscrew (http://www.agroman.net/corkscrew/) is required for it to work and in system binary path."
    return 1
  fi

  _PROXY_HOST=`echo $HTTP_PROXY | sed 's/.*\/\/\(.*\)\:.*/\1/'`
  _IF_PROXY_AVAILABLE=`nslookup "$_PROXY_HOST" > /dev/null ; echo $?`
  if [ "$_IF_PROXY_AVAILABLE" != "0" ]; then
    echo "ERROR: Trying to use '${_PROXY_HOST}' as proxy for ssh. Not accessible."
    return 1
  fi

  _SSH_PROXY_CONFIG="ProxyCommand ${_CORKSCREW_BIN} ${_PROXY_HOST} 80 %h %p"

  _SSH_DIR="$HOME/.ssh"
  if [ ! -d "$_SSH_DIR" ]; then mkdir -p "$_SSH_DIR"; fi
  _SSH_CONFIG_FILE="$_SSH_DIR/config"
  if [ ! -f "$_SSH_CONFIG_FILE" ]; then
    touch "$_SSH_CONFIG_FILE" && chmod 0544 "$_SSH_CONFIG_FILE"
  fi
  _IF_SSH_PROXY_EXISTS=`grep "$_SSH_PROXY_CONFIG" "$_SSH_CONFIG_FILE" > /dev/null; echo $?`
  if [ "$_IF_SSH_PROXY_EXISTS" = "0" ]; then
    unset_ssh_proxy
  fi

  echo $_SSH_PROXY_CONFIG | tee -a $_SSH_CONFIG_FILE

  unset _SSH_CONFIG_FILE
  unset _SSH_DIR
  unset _PROXY_HOST
  unset _CORKSCREW_BIN
}


unset_ssh_proxy(){
  _SSH_CONFIG_FILE="$HOME/.ssh/config"
  if [ $# -ge 1 ]; then _SSH_CONFIG_FILE="$1" ; fi
  _SSH_CONFIG=`grep -v 'ProxyCommand.*' $_SSH_CONFIG_FILE`
  echo $_SSH_CONFIG > $_SSH_CONFIG_FILE
}


set_proxy(){
  if [ $# -ne 1 ]; then
    echo "Wrong Syntax."
    echo "Syntax: $0 <entire-string-to-set-full-url-with-port-user-password>"
    return 1
  fi
  PROXY_ENV="http_proxy ftp_proxy https_proxy rsync_proxy all_proxy auto_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY AUTO_PROXY NO_PROXY"
  for envar in `echo $PROXY_ENV`
  do
    echo $envar
    export $envar="$1"
  done
  #set_ssh_proxy

  #export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
  echo -e "Proxy environment variable set."
}
alias set_proxy_polipo="set_proxy 'http://127.0.0.1:8123'"

unset_proxy(){
  PROXY_ENV="http_proxy ftp_proxy https_proxy rsync_proxy all_proxy auto_proxy no_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY ALL_PROXY AUTO_PROXY NO_PROXY"
  for _envar in `echo $PROXY_ENV`
  do
    echo "Unset $_envar"
    unset "$_envar"
  done
  #unset_ssh_proxy

  echo -e "Proxy environment variable removed."
}

7zip(){
  7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on "$1" "$2"
}

alias 7unzip="7z e"

alias del_vim_swap="find -name *.sw[lmnop] | xargs rm -f"

alias es_start="sudo elasticsearch -p /tmp/elasticsearch.pid"

alias fix-fs-fat="fsck.vfat -favrt"
alias fix-fs-ntfs="ntfsck -favrt"

alias cinnamon-remove-recent="cat /dev/null > .local/share/recently-used.xbel"

boomark(){
  echo "$@" | tee -a $HOME/.boomark.abk
}

alias time-brisbane="TZ=Australia/Brisbane date"

nicUp(){
  sudo ip link set dev $1 up
}
nicDown(){
  sudo ip link set dev $1 down
}

xtrakt-size(){
  local _COMPRESSED_FILE="$1"
  local _COMPRESSED_FILE_LIST=". . ERROR:No-FileList"

  if [[ -f "$_COMPRESSED_FILE" ]]; then
    case "$_COMPRESSED_FILE" in
    *.tar.bz2) _COMPRESSED_FILE_LIST="tar tvjf '$_COMPRESSED_FILE'"              ;;
    *.tar.gz)  _COMPRESSED_FILE_LIST="tar tvzf '$_COMPRESSED_FILE'"              ;;
    *.bz2)     _COMPRESSED_FILE_LIST="bunzip2 -cd '$_COMPRESSED_FILE' | wc -c"   ;;
    *.rar)     echo "WIP"                                         ;;
    *.gz)      _COMPRESSED_FILE_LIST="gunzip -l '$_COMPRESSED_FILE' | awk '{print $3,$1,$2,$NF}' | tail -n +2"  ;;
    *.tar)     _COMPRESSED_FILE_LIST="tar tvf '$_COMPRESSED_FILE'"               ;;
    *.tbz2)    _COMPRESSED_FILE_LIST="tar tvjf ''$_COMPRESSED_FILE'"             ;;
    *.tgz)     _COMPRESSED_FILE_LIST="tar tvzf '$_COMPRESSED_FILE'"              ;;
    *.zip)     _COMPRESSED_FILE_LIST="unzip -l '$_COMPRESSED_FILE' | tail -1 | awk '{print \$3,\$2,\$1}'"       ;;
    *.Z)       echo "WIP"                                         ;;
    *.7z)      _COMPRESSED_FILE_LIST="7z l '$_COMPRESSED_FILE' | tail -1"        ;;
    *)         echo "don't know how to uncompress '$_COMPRESSED_FILE'..."        ;;
    esac
  else
    echo "'$_COMPRESSED_FILE' is not a valid file!"
  fi

  eval "$_COMPRESSED_FILE_LIST" | awk '{s+=$3} END{print (s/1024/1024),"MB"}'
}

xtrakt () {
  local _COMPRESSED_FILE="$1"

  if [[ -f "$_COMPRESSED_FILE" ]]; then
    case "$_COMPRESSED_FILE" in
    *.tar.bz2)   tar xvjf "$_COMPRESSED_FILE"          ;;
    *.tar.gz)    tar xvzf "$_COMPRESSED_FILE"          ;;
    *.bz2)       bunzip2 -k -d "$_COMPRESSED_FILE"     ;;
    *.rar)       unrar x "$_COMPRESSED_FILE"           ;;
    *.gz)        gunzip "$_COMPRESSED_FILE"            ;;
    *.tar)       tar xvf "$_COMPRESSED_FILE"           ;;
    *.tbz2)      tar xvjf "$_COMPRESSED_FILE"          ;;
    *.tgz)       tar xvzf "$_COMPRESSED_FILE"          ;;
    *.zip)       unzip "$_COMPRESSED_FILE"             ;;
    *.Z)         uncompress "$_COMPRESSED_FILE"        ;;
    *.7z)        7z x "$_COMPRESSED_FILE"              ;;
    *.xz)        cp "$_COMPRESSED_FILE" "__TMP__${_COMPRESSED_FILE}" && \
                    xz --decompress "__TMP__${_COMPRESSED_FILE}" && \
                    mv $(echo "__TMP__${_COMPRESSED_FILE}" | sed 's/.xz$//') $(echo "$_COMPRESSED_FILE" | sed 's/.xz$//') ;;
    *)           echo "don't know how to uncompress '$_COMPRESSED_FILE'..." ;;
    esac
  else
    echo "It uses file extension for identification. Extension of '$_COMPRESSED_FILE' is not supported yet!"
  fi
}

mount-iso(){
  _ISOFILE="$1"
  _MOUNTPOINT="$2"
  mount -o loop $_ISOFILE $_MOUNTPOINT
}

exectime(){
  time -f '%Uu %Ss %er %MkB %C' "$@"
}

dug(){
  dig +short -x $(dig +short $1)
}

### fixing common typos to work
alias cdd="cd"

#################### from github.com/shazow :: begin
### Find file in cwd
function f () {
  find . -name "*$**"
}

### Find directory under cwd and cd into it
fcd() {
  target=$(find . -name "*$**" -type d | head -n1)
  if [[ "$target"  ]]; then
    cd "$target"
  else
    echo "Directory not found: $*"; return
  fi
}

### Find directory under cwd and cd into it with choice
zcd() {
  local dirfuzz="$*"
  local targets=$(find . -iname "*${dirfuzz}*" -type d | sed 's/^\s*//' | sed 's/\s*$//')

  [[ -z "${targets}" ]] && echo "[error] nothing like this found" && return 1
  local targets_idx=0
  for _t in $(echo $targets); do
    ((targets_idx=targets_idx+1))
    echo "[${targets_idx}] $_t"
  done
  echo -n "which index to change dir into: " && read target_idx
  [[ -z "${target_idx}" ]] && target_idx=0
  ((targets_idx=0))
  for _t in $(echo $targets); do
    ((targets_idx=targets_idx+1))
    [[ $targets_idx -ne $target_idx ]] && continue
    cd "$_t" && return
  done
  echo "Directory/Index not found: $*"; return
}

### find directory in fuzzy mode and cd with choice
z(){
  local dirfuzz="$*"
  dirfuzz=$(echo $dirfuzz | sed 's/\s*/\*/g')
  dirfuzz="${dirfuzz:1:-1}"

  local targets=$(find . -iname "*${dirfuzz}*" -type d | sed 's/^\s*//' | sed 's/\s*$//')

  [[ -z "${targets}" ]] && echo "[error] nothing like this found" && return 1
  local targets_idx=0
  for _t in $(echo $targets); do
    ((targets_idx=targets_idx+1))
    echo "[${targets_idx}] $_t"
  done
  echo -n "which index to change dir into: " && read target_idx
  [[ -z "${target_idx}" ]] && target_idx=0
  ((targets_idx=0))
  for _t in $(echo $targets); do
    ((targets_idx=targets_idx+1))
    [[ $targets_idx -ne $target_idx ]] && continue
    cd "$_t" && return
  done
  echo "Directory/Index not found: $*"; return
}

### bak to backup target as target.bak
function bak() {
  t="$1";
  if [[ "${t:0-1}" == "/"  ]]; then
    t=${t%%/}; # Strip trailing / of directories
  fi
  mv -v $t{,.bak}
}
function unbak() { # Revert previously bak'd target
  t="$1";
  if [[ "${t:0-1}" == "/"  ]]; then
    t="${t%%/}"; # Strip trailing / of directories
  fi
  if [[ "${t:0-4}" == ".bak"  ]]; then
    mv -v "$t" "${t%%.bak}"
  else
    echo "No .bak extension, ignoring: $t"
  fi
}
alias lsdir='find . -type d -maxdepth 1'
alias cdrandom='cd "$(lsdir | randomline $(lsdir | wc -l))"'
#################### from github.com/shazow :: end

### cli command history
if [[ "$BASH" != "" ]]; then
  export HISTFILE=$HOME/.bash_history
elif [[ "$ZSH_NAME" != "" ]]; then
  export HISTFILE=$HOME/.zsh_history
else
  export HISTFILE=$HOME/.cli_history
fi
export HISTSIZE=1000000
export SAVEHIST=1000000

### empty buffers cache
free_buffer_cache(){
  free && sync
  sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
  free
}

ls-filetypes(){
  local _LS_AT=$1
  [[ -z "$_LS_AT" ]] && _LS_AT="$PWD"
  find . -maxdepth 1 -type f | awk -F'.' '{print $NF}' | sort | uniq
}
