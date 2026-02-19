# profile for cli

alias ls='ls --color=auto'
alias rdp="rdesktop-vrdp -u administrator -p -"

alias T='tree -u -p -h -Q -F'

alias ack="ack --ignore-dir=.venv --ignore-dir=.git"

alias sudo-vim="sudo -E vim"

uhoh-scr(){
  xscreensaver-command -lock
}
uhoh(){
  xlock
}

grep-for(){
  local _PATTERN="$1"
  local _SEARCH_AT="$2"
  [[ -z "${_PATTERN}" ]] && echo "$ grep-for <pattern> [<search-path>]" && return 1
  [[ -z "${_SEARCH_AT}" ]] && _SEARCH_AT="."
  grep -r "${_PATTERN}" ${_SEARCH_AT} | awk -F':' '{print $1}' | sort | uniq
}

fuzzPathsList(){
  ## used in collaboration with 'fuzzPathsValue'
  ## check it's comments for full picture
  local pathfuzz="$*"
  pathfuzz=$(echo $pathfuzz | sed 's/\s*/\*/g')
  pathfuzz="${pathfuzz:1:-1}"

  local targets=$(find . -iname "*${pathfuzz}*" | sed 's/^\s*//' | sed 's/\s*$//')

  [[ -z "${targets}" ]] && echo "[error] nothing like this found" && return 1
  local targets_idx=0
  for _t in $(echo $targets); do
    ((targets_idx=targets_idx+1))
    echo "[${targets_idx}] $_t"
  done
}

fuzzPathsValue(){
  ## in caller foo
  ## use fuzzPathsList to show options to user,
  ## then something as following to get the option
  ## #### echo -n "which index to change dir into: " && read target_idx
  ## then call this foo with <option-input> <input-of-fuzzPathsList>

  local pathIdx="$1"
  local pathfuzz="${@:2}"
  pathfuzz=$(echo $pathfuzz | sed 's/\s*/\*/g')
  pathfuzz="${pathfuzz:1:-1}"

  local targets=$(find . -iname "*${pathfuzz}*" | sed 's/^\s*//' | sed 's/\s*$//')

  [[ -z "${targets}" ]] && echo "." && return 1

  ((targets_idx=0))
  for _t in $(echo $targets); do
    ((targets_idx=targets_idx+1))
    [[ $targets_idx -ne $pathIdx ]] && continue
    echo "$_t" && return
  done
  echo "."; return 123
}

vimm(){
  local vimTarget="$1"

  [[ -z "${vimTarget}" ]] && vimTarget='.'

  if [[ "${vimTarget}" != '.' ]]; then
    fuzzPathsList "${vimTarget}"
    echo -n "which index to change dir into: " && read pathIdx
    [[ -z "${pathIdx}" ]] && pathIdx=0
    vimTarget=$( fuzzPathsValue "${pathIdx}" "${vimTarget}" )
  fi

  vim "${vimTarget}"
}

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

alias ls-dirs="find . -maxdepth 1 -type d"
alias ls-files="find . -maxdepth 1 -type f"

ls-top10files(){
  local _CHECK_THIS_PATH="$1"
  find $_CHECK_THIS_PATH -type f -exec ls -sh {} \; | sort -n -r | head -10
}

alias items='ls -1 | wc -l'
alias mysize='du -h | grep -e "\.$" | cut -f1'

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


ascii_art_from_data(){
    local _dat="$1"
    local _msg="${@:2}"
    if [[ -z "${_msg}" ]]; then
      local _msg=`date`
    fi
    if [[ ! -z "${MY_DOTFILE_DIR}" ]]; then
      local ASCII_ART_DATA=$(dirname ${MY_DOTFILE_DIR})"/tasks/shell/data/${_dat}"
      [[ -f "${ASCII_ART_DATA}" ]] && cat "${ASCII_ART_DATA}"
      echo ''
    fi
    echo "${_msg}"
    echo ''
}

ascii_pacman(){
    ascii_art_from_data "pacman.ascii-art" " o  o $@"
}

ascii_kawaii(){
    ascii_art_from_data "kawaii.ascii-art" "$@"
}

ascii_maxpayne(){
    ascii_art_from_data "maxpayne.ascii-art" "$@"
}

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

clean-ssh-fingerprint(){
  local OF_NODE="$1"
  [[ -z "${OF_NODE}" ]] && echo "[err] wrong usage; '$0 <of-node> [<known-hosts-file>]'" && return 123
  local SSH_KNOWN_HOSTS="$2"
  [[ -z "${SSH_KNOWN_HOSTS}" ]] && SSH_KNOWN_HOSTS="$HOME/.ssh/known_hosts"
  [[ ! -f "${SSH_KNOWN_HOSTS}" ]] && echo "[err] ${SSH_KNOWN_HOSTS} not found" && return 123

  for LINE_NUMBER in $(grep -nr ${OF_NODE} ${SSH_KNOWN_HOSTS} | awk -F':' '{print $1}'); do
    sed -i -e "${LINE_NUMBER}s/.*\r*\n*\s*//" "${SSH_KNOWN_HOSTS}"
    grep -v '^$' "${SSH_KNOWN_HOSTS}" | tee "${SSH_KNOWN_HOSTS}"
  done
}

forever-no-more(){
  local MY_TASK_PATTERN="$@"
  local FOREVER_TILL_PATTERN="/tmp/.abk.forever*"

  for forever_pid in $(eval "ls -1 ${FOREVER_TILL_PATTERN}"); do
    [[ $(grep -c "${MY_TASK_PATTERN}" ${forever_pid}) -ne 0 ]] && rm -i "${forever_pid}"
  done
}

forever(){
  local MY_TASK="$@"
  local FOREVER_TILL="/tmp/.abk.forever"$(date +%s)

  touch ${FOREVER_TILL}
  echo "${MY_TASK}" | tee -a "${FOREVER_TILL}"
  while :
    do
    echo '----------------'
    echo "[INFO] to stop, rm ${FOREVER_TILL}"
    echo '----------------'
    eval "$MY_TASK" ;
     if [[ ! -f "${FOREVER_TILL}" ]];
     then
	     break       	   #Abandon the loop.
     fi
  done
}

top-resource-eaters(){
  local _PROC_COUNT=$1
  [[ -z "${_PROC_COUNT}" ]] && _PROC_COUNT=10
  ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -${_PROC_COUNT}
}

ascii-perseverent-face(){
  echo 'ゞ( ͡°⍛ ͡°)و'
}

pipevim(){
  [[ $# -lt 1 ]] && echo "no command passed" && exit 1
  eval "$@" 2>&1 | vim -
}
alias pvim="pipevim"

pipeless(){
  [[ $# -lt 1 ]] && echo "no command passed" && exit 1
  eval "$@" 2>&1 | less
}
alias pless="pipeless"

pipemore(){
  [[ $# -lt 1 ]] && echo "no command passed" && exit 1
  eval "$@" 2>&1 | more
}

run-it(){
  local _cmd="$@"
  local _cmd_type=$(echo "${_cmd}" | sed 's/ .*//g')
  local _checksum=$(echo "${_cmd}" | base64)

  [[ -z "${RUN_IT_CACHE_DIR}" ]] && \
    RUN_IT_CACHE_DIR="/tmp/run-it"
  [[ ! -d "${RUN_IT_CACHE_DIR}" ]] && \
    mkdir -p "${RUN_IT_CACHE_DIR}"
  local _cache_file="${RUN_IT_CACHE_DIR}/${_cmd_type}.${_checksum}"

  if [[ $(echo "${RUN_IT_CACHE_DISABLED}!" | tr '[:upper:]' '[:lower:]') == "true!" ]]; then
    eval $_cmd
    return
  fi

  [[ ! -f "${_cache_file}" ]] && \
    eval $_cmd > "${_cache_file}"

  cat "${_cache_file}"
}

toPDF(){
  local SRC_FILE="$1"
  pandoc --pdf-engine=pdflatex -V CJKmainfont="KaiTi" "${SRC_FILE}" -o "${SRC_FILE}.pdf"
}
alias to-pdf="toPDF"

md2pdf(){
  local SRC_FILE="$1"
  pandoc --pdf-engine=pdfroff --toc-depth=1 "${SRC_FILE}" -o "${SRC_FILE}.pdf"
}

pdf-for-ebook(){
  ps2pdf -dPDFSETTINGS=/ebook "${1}" "${1}-ps2.pdf"
}

djvu-to-pdf(){
  # required package: djvulibre
  ddjvu -format=pdf "${1}" "${1}.pdf"
}

epub-to-pdf(){
  ebook-convert "${1}" "${1}-pandoc.pdf" --enable-heuristics
}

if [[ -f "/etc/redhat-release" ]]; then
  run-security-updates(){
    sudo dnf update --security
  }
fi
