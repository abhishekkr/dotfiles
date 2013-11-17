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
