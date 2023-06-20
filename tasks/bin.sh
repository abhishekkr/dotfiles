HOME_BINDIR="${HOME}/bin"
HOME_A_BINDIR="${HOME}/ABK/bin"
mkdir -p $HOME_BINDIR
mkdir -p $HOME_A_BINDIR

############################### _lib

download-release-from-github(){
  local REPO_PATH="$1"
  local REPO_VERSION="$2"
  local TAR_GZ="$3"

  local GITHUB_DDL_HEADERS=$(curl -Iks "https://github.com/${REPO_PATH}/releases/download/${REPO_VERSION}/${TAR_GZ}")

  local URLTO_DDL=$(echo "$GITHUB_DDL_HEADERS"  | grep '^Location: ' | awk '{print $2}' | sed 's/[[:space:]]*$//g')
  local HEADER_GITHUB_REQUEST_ID=$(echo "$GITHUB_DDL_HEADERS"  | grep '^X-GitHub-Request-Id: ' | awk '{print $2}' | sed 's/[[:space:]]*$//g')
  local HEADER_REQUEST_ID=$(echo "$GITHUB_DDL_HEADERS"  | grep '^X-Request-Id: ' | awk '{print $2}' | sed 's/[[:space:]]*$//g')

  curl -H "X-GitHub-Request-Id: ${HEADER_GITHUB_REQUEST_ID}" -H "X-Request-Id: ${HEADER_REQUEST_ID}" -Lk -o "${TAR_GZ}" "${URLTO_DDL}"
}

download-archive-from-github(){
  local REPO_PATH="$1"
  local REPO_VERSION="$2"
  local TAR_GZ="$3"

}

setup-from-github(){
  local REPO_PATH="$1"
  local REPO_VERSION="$2"
  local TAR_GZ="$3"
  local SETUP_CMD="$4"
  local RELEASE_OR_ARCHIVE=${5:-release}

  set -ex

  pushd /tmp
  if [[ "${RELEASE_OR_ARCHIVE}" == "release" ]]; then
    download-release-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}"
  elif [[ "${RELEASE_OR_ARCHIVE}" == "archive" ]]; then
    local TARBALL_URI="https://github.com/${REPO_PATH}/archive/${TAR_GZ}"
    wget -c -O "${TAR_GZ}" "${TARBALL_URI}"
  else
    echo "[error] unidentified github download type"
  fi
  tar zxvf "${TAR_GZ}"
  eval "${SETUP_CMD}"
  rm  "${TAR_GZ}"
  popd

  set +ex
}

############################## _setup_lib

setup-yaml2json(){
  [[ ! -f "${HOME_BINDIR}/yaml2json" ]] && \
    cp $(dirname $0)/../dot.code/yaml2json "${HOME_BINDIR}/yaml2json"
}

setup-rust(){
  [[ $(rustc --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* rust is already setup" && \
    return 0

  curl https://sh.rustup.rs -sSf | sudo sh
}

setup-jq(){
  [[ $(jq --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* jq is already setup" && \
    return 0

  jq_url="http://stedolan.github.io/jq/download/linux64/jq"
  jq_fylname="$HOME_BINDIR/jq"
  wget -O "${jq_fylname}" -c "${jq_url}"
  chmod +x "${jq_fylname}"
  echo "placed: ${jq_fylname}"
}

setup-plantuml(){
  plantuml_url="https://excellmedia.dl.sourceforge.net/project/plantuml/plantuml.jar"
  plantuml_fylname="$HOME_BINDIR/plantuml.jar"

  [[ -f "${plantuml_fylname}" ]] && \
    echo "* plantuml is already setup" && \
    return 0

  curl -Lk -o "${plantuml_fylname}" "${plantuml_url}"
  chmod +x "${plantuml_fylname}"
  echo "placed: ${plantuml_fylname}"
}

setup-chruby(){
  local CHRUBY_VERSION="0.3.9"
  local CHRUBY_DIR="chruby-${CHRUBY_VERSION}"
  local FILE_TO_SOURCE="/usr/local/share/chruby/chruby.sh"

  local REPO_PATH="postmodern/chruby"
  local REPO_VERSION="v${CHRUBY_VERSION}"
  local TAR_GZ="${REPO_VERSION}.tar.gz"
  local SETUP_CMD="pushd \"${CHRUBY_DIR}\" ; sudo ./scripts/setup.sh ; popd ; rm -rf \"${CHRUBY_DIR}\""

  [[ -f "${FILE_TO_SOURCE}" ]] && \
    echo "* chruby is already setup" && \
    return 0

  setup-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}" "${SETUP_CMD}" "archive"

  source "${FILE_TO_SOURCE}"
}

setup-ruby-install(){
  local RUBY_INSTALL_VERSION="0.7.0"
  local RUBY_INSTALL_DIR="ruby-install-${RUBY_INSTALL_VERSION}"

  local REPO_PATH="postmodern/ruby-install"
  local REPO_VERSION="v${RUBY_INSTALL_VERSION}"
  local TAR_GZ="${REPO_VERSION}.tar.gz"
  local SETUP_CMD="pushd \"${RUBY_INSTALL_DIR}\" ; sudo ./setup.sh ; popd ; rm -rf \"${RUBY_INSTALL_DIR}\""

  [[ $(ruby-install --version | awk '{print $2}') == "${RUBY_INSTALL_VERSION}" ]] && \
    echo "* ruby-install is already setup" && \
    return 0

  setup-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}" "${SETUP_CMD}" "archive"
}

setup-packetbeat(){
  local pbeat_version="6.3.1"
  local pbeat_tardir="packetbeat-${pbeat_version}-linux-x86_64"
  local pbeat_url="https://artifacts.elastic.co/downloads/beats/packetbeat/${pbeat_targz}.tar.gz"
  local dst_pbeat_dir="${HOME_A_BINDIR}/packetbeat"

  [[ ! -x "${dst_pbeat_dir}/packetbeat" ]] && \
    echo "* packetbeat is already setup" && \
    return 0

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

setup-leiningen(){
  local LEIN_INSTALL_URL="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
  local LEIN_INSTALL_FILE="${HOME_BINDIR}/lein"

  [[ $(lein --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* lein is already setup" && \
    return 0

  wget -c -O "${LEIN_INSTALL_FILE}" "${LEIN_INSTALL_URL}"

  chmod +x "${LEIN_INSTALL_FILE}"
  bash -c "${LEIN_INSTALL_FILE}"
}

setup-fzf(){
  local REPO_PATH="junegunn/fzf-bin"
  local REPO_VERSION="0.17.5"
  local TAR_GZ="fzf-0.17.5-linux_amd64.tgz"
  local SETUP_CMD="mv ./fzf ${HOME_BINDIR}/fzf"

  [[ $(fzf --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* fzf is already setup" && \
    return 0

  setup-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}" "${SETUP_CMD}"
}

setup-bcat(){
  local BIN_NAME="bcat"  ## instead of just bat; to avoid conflict
  local REPO_PATH="sharkdp/bat"
  local REPO_VERSION="v0.12.1"
  local TAR_GZ="bat-${REPO_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
  local SETUP_CMD="mv bat-${REPO_VERSION}-x86_64-unknown-linux-gnu/bat ${HOME_BINDIR}/${BIN_NAME} ; rm -rf bat-${REPO_VERSION}-x86_64-unknown-linux-gnu"

  [[ $(${BIN_NAME} --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* ${BIN_NAME} (bat) is already setup" && \
    return 0

  setup-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}" "${SETUP_CMD}"
}

setup-diskus(){
  local REPO_PATH="sharkdp/diskus"
  local REPO_VERSION="v0.6.0"
  local TAR_GZ="diskus-${REPO_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
  local SETUP_CMD="mv diskus-${REPO_VERSION}-x86_64-unknown-linux-gnu/diskus ${HOME_BINDIR}/diskus ; rm -rf diskus-${REPO_VERSION}-x86_64-unknown-linux-gnu"

  [[ $(diskus --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* diskus is already setup" && \
    return 0

  setup-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}" "${SETUP_CMD}"
}

setup-hyperfine(){
  local REPO_PATH="sharkdp/hyperfine"
  local REPO_VERSION="v1.8.0"
  local TAR_GZ="hyperfine-${REPO_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
  local SETUP_CMD="mv hyperfine-${REPO_VERSION}-x86_64-unknown-linux-gnu/hyperfine ${HOME_BINDIR}/hyperfine ; rm -rf hyperfine-${REPO_VERSION}-x86_64-unknown-linux-gnu"

  [[ $(hyperfine --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* hyperfine is already setup" && \
    return 0

  setup-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}" "${SETUP_CMD}"
}

setup-ffind(){
  local BIN_NAME="ffind"  ## instead of just fd; to avoid conflict
  local REPO_PATH="sharkdp/fd"
  local REPO_VERSION="v7.4.0"
  local TAR_GZ="fd-${REPO_VERSION}-x86_64-unknown-linux-gnu.tar.gz"
  local SETUP_CMD="mv fd-${REPO_VERSION}-x86_64-unknown-linux-gnu/fd ${HOME_BINDIR}/${BIN_NAME} ; rm -rf fd-${REPO_VERSION}-x86_64-unknown-linux-gnu"

  [[ $(${BIN_NAME} --version &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* ${BIN_NAME} (fd) is already setup" && \
    return 0

  setup-from-github "${REPO_PATH}" "${REPO_VERSION}" "${TAR_GZ}" "${SETUP_CMD}"
}

setup-nvm(){
  local BIN_NAME="nvm"
  local BIN_VERSION="0.35.3"
  local INSTALL_SCRIPT_URI="https://raw.githubusercontent.com/nvm-sh/nvm/v${BIN_VERSION}/install.sh"

  [[ $(whcih ${BIN_NAME} &>/dev/null ; echo $?) -eq 0 ]] && \
    echo "* ${BIN_NAME} (bat) is already setup" && \
    return 0

  curl -o- "${INSTALL_SCRIPT_URI}" | bash
  ## live load
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
}

setup-poetry(){
  python3 -m pip install --user pipx
  python3 -m pipx ensurepath
  pipx install poetry
}

##### main()

setup-poetry
setup-yaml2json
setup-rust
setup-jq
setup-plantuml
setup-fzf
setup-bcat
setup-diskus
setup-hyperfine
setup-ffind
setup-chruby
setup-ruby-install
setup-packetbeat
setup-leiningen
setup-nvm
