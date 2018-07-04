
[[ -d "${HOME}/.cargo/bin" ]] && export PATH="${PATH}:${HOME}/.cargo/bin"

rustrun(){
  local _RUST_FILE="$1"
  local _RUST_BIN=$(basename "${_RUST_FILE}" | sed 's/.rs$//')
  rustc "${_RUST_FILE}" && "./${_RUST_BIN}"
}
