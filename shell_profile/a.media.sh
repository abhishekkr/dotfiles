# .bashrc

alias mute="(amixer get Master | grep off > /dev/null && amixer -q set Master unmute) || amixer -q set Master mute"
alias volumeUp="amixer -c 0 set PCM 5dB+ unmute"
alias volumeDown="amixer -c 0 set PCM 5dB-"

play-from-log(){
  if [ $# -eq 0 ]; then
    echo "SYNTAX: play-from-log <log-file-with-path-entries>" && return 1
  fi
  cat $1 | xargs -I {} mplayer -quiet {}
}

mplayeraa(){
  mplayer -vo aa "$@"
}
mplayernov(){
  mplayer -vo no "$@"
}
mplayernoa(){
  mplayer -ao no "$@"
}

media2avi(){
  source_media=$1
  if [ $# -eq 0 ]; then
    echo "SYNTAX: media2avi <source-file> <destination-avi>" && return 1
  elif [ $# -eq 1 ]; then
    dest_media="${source_media}.avi"
  fi

  ffmpeg -i "$source_media" -qscale 0 "$dest_media"
}

xopen(){
  xdg-open "$@" ; _TMP_EXITCODE=$?
  if [ "${_TMP_EXITCODE}" == "1" ]; then
    echo "[ERROR:] Error in command line syntax"
  elif [ "${_TMP_EXITCODE}" == "2" ]; then
    echo "[ERROR:] One of the files passed on the command line did not exist"
  elif [ "${_TMP_EXITCODE}" == "3" ]; then
    echo "[ERROR:] A required tool could not be found"
  elif [ "${_TMP_EXITCODE}" == "4" ]; then
    echo "[ERROR:] The action failed"
  fi
  return $_TMP_EXITCODE
}

  #sudo systemctl restart bluetooth
  #bluetoothctl
    # power on
    # agent on
    # default-agent
    # scan on

    # for file in *.JPG; do convert -resize 1600x1200 -- "$file" "${file%%.jpg}-resized.jpg"; done

alias resizeJPG="mkdir -p resized ; for file in *.jpg; do convert -resize 1600x1200 -- \"\$file\" \"resized/\${file%%.jpg}-resized.jpg\"; done"

toMP4(){
  for _MEDIAFILE in "$@"
  do
      echo "converting $_MEDIAFILE"
      ffmpeg -i "${_MEDIAFILE}" -acodec libmp3lame  -vcodec libx264 -preset slow -flags +aic+mv4 "${_MEDIAFILE}.mp4"
  done
  unset _MEDIAFILE
}

uget(){
  echo "$1" | sed 's/%3A/\:/g' | sed 's/%2F/\//g' | sed 's/%3F/?/g' | sed 's/%3D/\=/g' | sed 's/%26/\&/g' | xargs wget -c
}

