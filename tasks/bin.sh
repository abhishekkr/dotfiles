HOME_BINDIR="${HOME}/bin"
HOME_A_BINDIR="${HOME}/ABK/bin"
mkdir -p $HOME_BINDIR
mkdir -p $HOME_A_BINDIR

setup_jq(){
  jq_url="http://stedolan.github.io/jq/download/linux64/jq"
  jq_fylname="$HOME_BINDIR/jq"
  wget -O "${jq_fylname}" -c "${jq_url}"
  chmod +x "${jq_fylname}"
  echo "placed: ${jq_fylname}"
}

setup_plantuml(){
  plantuml_url="https://excellmedia.dl.sourceforge.net/project/plantuml/plantuml.jar"
  plantuml_fylname="$HOME_BINDIR/plantuml.jar"
  curl -Lk -o "${plantuml_fylname}" "${plantuml_url}"
  chmod +x "${plantuml_fylname}"
  echo "placed: ${plantuml_fylname}"
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

setup_packetbeat(){
  local pbeat_version="6.3.1"
  local pbeat_tardir="packetbeat-${pbeat_version}-linux-x86_64"
  local pbeat_url="https://artifacts.elastic.co/downloads/beats/packetbeat/${pbeat_targz}.tar.gz"
  local dst_pbeat_dir="${HOME_A_BINDIR}/packetbeat"

  pushd /tmp
  curl -skLO $pbeat_url
  tar zxf "${pbeat_tardir}.tar.gz"
  mv ${pbeat_tardir} ${dst_pbeat_dir}
  echo ${version} > "${dst_pbeat_dir}/version"
  sed -i 's/^output.elasticsearch\:/output.console:/' "${dst_pbeat_dir}/packetbeat.yml"
  sed -i 's/hosts\: \["localhost\:9200"\]$/pretty: true/' "${dst_pbeat_dir}/packetbeat.yml"
  sudo chown root "${dst_pbeat_dir}/packetbeat.yml"
  popd

  echo "sudo ${dst_pbeat_dir}/packetbeat -c ${dst_pbeat_dir}/packetbeat.yml" > "${HOME_BINDIR}/packetbeat-run"
  chmod +x "${HOME_BINDIR}/packetbeat-run"
}

setup_leiningen(){
  local LEIN_INSTALL_URL="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
  local LEIN_INSTALL_FILE="${HOME_BINDIR}/lein"

  wget -c -O "${LEIN_INSTALL_FILE}" "${LEIN_INSTALL_URL}"

  chmod +x "${LEIN_INSTALL_FILE}"
  bash -c "${LEIN_INSTALL_FILE}"
}

setup_jq
setup_plantuml
#setup_chruby
#setup_ruby_install
