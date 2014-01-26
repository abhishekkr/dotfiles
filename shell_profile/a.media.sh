# .bashrc

alias music3a='mplayer -shuffle /media/ABK_3a/ABK/_Music/*mp3 /media/ABK_3a/ABK/_Music/*/*mp3 /media/ABK_3a/ABK/_Music/*/*/*mp3 /media/ABK_3a/ABK/_Music/*/*/*/*mp3 /media/ABK_3a/ABK/_Music/*/*/*/*/*mp3 /media/ABK_3b/ABK/_chalchitra/_Music/*/*mp3 /media/ABK_3b/ABK/_chalchitra/_Music/*/*/*mp3 /media/ABK_3b/ABK/_chalchitra/_Music/*/*/*/*mp3'

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
