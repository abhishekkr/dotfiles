# .bashrc

alias mute="(amixer get Master | grep off > /dev/null && amixer -q set Master unmute) || amixer -q set Master mute"
alias volumeUp="amixer -c 0 set PCM 5dB+ unmute"
alias volumeDown="amixer -c 0 set PCM 5dB-"

gaana-gaao(){
  [[ -z "$SONGS_DIR" ]] && echo "[err] don't know where your songs are" && return
  local SONG_PATTERN="$1"
  find ${SONGS_DIR} -type f | grep -i ${SONG_PATTERN} > $HOME/.gaana.lst
  mplayer -vo no -quiet -shuffle -playlist $HOME/.gaana.lst
}

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

mergeVdoAdo(){
  if [[ $# -ne 3 ]]; then
    echo "USAGE: mergeVdoAdo <video-input> <audio-input> <output-filename>" ; exit 1
  fi
  ffmpeg -i "$1" -i "$2" -c:v copy -c:a aac -strict experimental "$3"
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
alias to-mp4="toMP4"

toMKV(){
  for _MEDIAFILE in "$@"
  do
      echo "converting $_MEDIAFILE"
      local _MKVNAME=$(echo "${_MEDIAFILE}" | sed 's/\/[A-Za-z0-9]$//')".mkv"
      ffmpeg -i "${_MEDIAFILE}" "${_MKVNAME}"
  done
  unset _MEDIAFILE _MKVNAME
}
alias to-mkv="toMKV"


toMP3(){
  for _MEDIAFILE in "$@"
  do
      echo "converting $_MEDIAFILE"
      ffmpeg -i "${_MEDIAFILE}" -codec:a libmp3lame -qscale:a 2 "${_MEDIAFILE}.mp3"
  done
  unset _MEDIAFILE
}
alias to-mp3="toMP3"

toFLAC(){
  for _MEDIAFILE in "$@"
  do
      echo "converting $_MEDIAFILE"
      ffmpeg -i "${_MEDIAFILE}" "${_MEDIAFILE}.flac"
  done
  unset _MEDIAFILE
}
alias to-flac="toFLAC"

toGIF(){
  local MEDIA_FILE="$@"
  local GIF_FILE="${MEDIA_FILE}.gif"
  ffmpeg -i "${MEDIA_FILE}" -vf "fps=10" -c:v pam -f image2pipe - | \
    convert -delay 10 - -loop 0 -layers optimize "${GIF_FILE}"
}
alias to-gif="toGIF"

toMKVH265(){
  local MEDIA_FILE="$@"
  local MKV_FILE="${MEDIA_FILE}-h265.mkv"
  ffmpeg -i "${MEDIA_FILE}" -vcodec libx265 -crf 28 "${MKV_FILE}"
}
alias to-mkv-h265="toMKVH265"

toYTVdo(){
  local MEDIA_FILE="$@"
  local YT_FILE="${MEDIA_FILE}-yt.webm"
  ffmpeg -i ${MEDIA_FILE} -c:v libvpx-vp9 -b:v 0.33M -c:a libopus -b:a 96k \
    -filter:v scale=960x540 ${YT_FILE}
}
alias to-yt-vdo="toYTVdo"

toFhdVdo(){
  local MEDIA_FILE="$@"
  local FHD_FILE="hd-${MEDIA_FILE}"
  ffmpeg -i ${MEDIA_FILE} -vf scale=1280:720 ${FHD_FILE}
}
alias to-fhd-vdo="toFhdVdo"

uget(){
  echo "$1" | sed 's/%3A/\:/g' | sed 's/%2F/\//g' | sed 's/%3F/?/g' | sed 's/%3D/\=/g' | sed 's/%26/\&/g' | xargs wget -c
}

dlyv(){
  [[ $(which youtube-dl > /dev/null ; echo $?) -ne 0 ]] && \
    echo "[ERROR] youtube-dl utility not found" && \
    return 1

  youtube-dl $@
}

dlyx(){
  [[ $(which youtube-dl > /dev/null ; echo $?) -ne 0 ]] && \
    echo "[ERROR] youtube-dl utility not found" && \
    return 1

  youtube-dl -x $@
}

dlyv-lt-mb(){
  dlyv -f "best[filesize<${1}M]" ${@:2}
}

dly-pick(){
  local VID_URL="$1"
  local pick_line=$(youtube-dl -F "${VID_URL}" | sort | fzf)
  local pick=$(echo "${pick_line}" | awk '{print $1}')
  if [[ -z "${pick}" ]]; then
    echo "guess you skipped downloading.."
    return 0
  fi
  youtube-dl -f ${pick} "${VID_URL}"
}

pdf-to-pngs-to-pdf(){
  local SRC_PDFPATH="${1}"
  local DEST_PDFPATH="${2}"
  [[ -z "${DEST_PDFPATH}" ]] && DEST_PDFPATH=$(dirname "${SRC_PDFPATH}")"/imgonlyPDF-"$(basename "$SRC_PDFPATH")

  local SRCBASENAME=$(basename "$SRC_PDFPATH" | sed 's/.pdf$//')
  local WDIR="/tmp/today/${SRCBASENAME}"
  mkdir -p "${WDIR}"
  pushd "${WDIR}"
  echo "converting to pngs at ${WDIR}"
  pdftoppm -png "${SRC_PDFPATH}" prefix
  echo "converting to pdf at ${DEST_PDFPATH}"
  convert *.png "${DEST_PDFPATH}"
  popd
}

png-to-gif(){
  local PNG_FOR_PALETTE="$1"
  local SOURCE_PNG_PATTERN="$2"
  local OUTGIF="$3"
  local FRAMERATE="${4:-10}"

  [[ $# -lt 3 ]] && \
    echo "Wrong Usage. Syntax: png-to-gif <png-for-palette/any-src.png> <source/pattern-%1d.png> <output.gif> [<framerate default 10>]" && \
    return 123

  local TSNOW=$(date +%s)
  local PALETTEPNG="/tmp/palette-${TSNOW}.png"
  set -ex
  ffmpeg -i "$PNG_FOR_PALETTE" -vf "palettegen" "$PALETTEPNG"
  ffmpeg -framerate $FRAMERATE -i $SOURCE_PNG_PATTERN -i "$PALETTEPNG" -filter_complex "paletteuse" "${OUTGIF}"
  set +ex
}
