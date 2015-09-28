HOME_BINDIR="${HOME}/bin"
mkdir -p $HOME_BINDIR

setup_jq(){
  jq_url="http://stedolan.github.io/jq/download/linux64/jq"
  jq_fylname="$HOME_BINDIR/jq"
  wget -O "${jq_fylname}" -c "${jq_url}"
  chmod +x "${jq_fylname}"
  echo "placed: ${jq_fylname}"
}

setup_jq
