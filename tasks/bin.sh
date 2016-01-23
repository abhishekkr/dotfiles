HOME_BINDIR="${HOME}/bin"
mkdir -p $HOME_BINDIR

setup_jq(){
  jq_url="http://stedolan.github.io/jq/download/linux64/jq"
  jq_fylname="$HOME_BINDIR/jq"
  wget -O "${jq_fylname}" -c "${jq_url}"
  chmod +x "${jq_fylname}"
  echo "placed: ${jq_fylname}"
}

setup_chruby(){
  CHRUBY_VERSION="0.3.9"
  CHRUBY_DIR="chruby-${CHRUBY_VERSION}"
  CHRUBY_DIR_ABS="${HOME_BINDIR}/${CHRUBY_INSTALL_DIR}"
  CHRUBY_TARBALL_PATH="${HOME_BINDIR}/${CHRUBY_DIR}.tar.gz"
  CHRUBY_TARBALL_URI="https://github.com/postmodern/chruby/archive/v${CHRUBY_VERSION}.tar.gz"

  wget -c -O "$CHRUBY_TARBALL_PATH" "$CHRUBY_TARBALL_URI"

  cd "${HOME_BINDIR}" && tar -xzvf "${CHRUBY_DIR}.tar.gz"
  rm -f "${CHRUBY_DIR}.tar.gz" && rm -f "${CHRUBY_DIR}.tar.gz.asc"
  cd "${CHRUBY_DIR}"
  sudo ./scripts/setup.sh
  cd "${HOME_BINDIR}" && rm -rf "${CHRUBY_DIR}"
  source /usr/local/share/chruby/chruby.sh
}

setup_ruby_install(){
  local RUBY_INSTALL_VERSION="0.6.0"
  local RUBY_INSTALL_DIR="ruby-install-${RUBY_INSTALL_VERSION}"
  local RUBY_INSTALL_DIR_ABS="${HOME_BINDIR}/${RUBY_INSTALL_DIR}"
  local TARBALL_PATH="${HOME_BINDIR}/${RUBY_INSTALL_DIR}.tar.gz"
  local TARBALL_URI="https://github.com/postmodern/ruby-install/archive/v${RUBY_INSTALL_VERSION}.tar.gz"

  wget -c -O "${TARBALL_PATH}" "${TARBALL_URI}"

  cd "${HOME_BINDIR}" && tar -xzvf "${RUBY_INSTALL_DIR}.tar.gz"
  rm -f "${RUBY_INSTALL_DIR}.tar.gz"
  cd "${RUBY_INSTALL_DIR}"
  sudo ./setup.sh
  cd "${HOME_BINDIR}" && rm -rf "${RUBY_INSTALL_DIR}"
}

setup_jq
setup_chruby
setup_ruby_install
