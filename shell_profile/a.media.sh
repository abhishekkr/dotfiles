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
