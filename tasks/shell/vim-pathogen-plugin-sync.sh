#!/usr/bin/env bash
### adapted and revised from JordanSissel:dotfile/bin/vimplugin-sync.sh

_VIM_DIR="${HOME}/.vim"
_VIM_PLUGIN_LIST="$(dirname $0)/data/vim-pathogen-plugin-sync.list"

update_pathogen(){
  _PATHOGEN_VIM_URL="https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
  curl -Lk -o "${_VIM_DIR}/autoload/pathogen.vim" ${_PATHOGEN_VIM_URL}
  unset _PATHOGEN_VIM_URL
}

error_msg(){
  _ERROR_MSG="$1"
  echo -e '\e[7m\e[4m\e[31m\e[1m'
  echo "[ERROR] ${_ERROR_MSG}"
  echo -e '\e[0m\e[0m\e[0m\e[0m'
  unset _ERROR_MSG
}

special_plugins(){
  case "$1" in
    YouCompleteMe)
      echo "**************************** Installation of Plugin: YouCompleteMe"
      ./install.sh
      ;;
    vimproc.vim)
      echo "**************************** Installation of Plugin: VimProc"
      make
      ;;
    ghcmod-vim)
      echo "**************************** Installation of Plugin: GHC-Mod"
      cabal install ghc-mod
      ;;
    hindent.vim)
      echo "**************************** Installation of Plugin: Hindent"
      cabal install hindent
      ;;
    vim-easytags)
      echo "**************************** Installation of Plugin: Checking Ctags"
      ctags --version
      if [[ $? -ne 0 ]]; then
        error_msg "Exuberant Ctags (http://ctags.sourceforge.net/) 'exuberant-ctags', need to be installed manually."
      fi
    ;;
    *)
      echo "No Special Tasks for ${1}"
      ;;
    esac
}

add_vim_plugin() {
  repo="$1"
  basedir="$HOME/.vim/bundle"

  [ ! -d "$basedir" ] && mkdir -p "$basedir"

  case $repo in
    file:///*)
      local file_uri="${repo##*file:///}"
      local name=$(basename ${file_uri})
      local name_dir=${name%%\.[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]}
      local file_dir="${basedir}/${name_dir}/plugin"
      local file_path="${file_dir}/${name}"
      echo "downloading vim plug-in to '${file_dir}': ${file_uri}"
      if [[ ! -d "${file_path}" ]] ; then
        mkdir -p "${file_dir}"
        wget -c -O "${file_path}" "${file_uri}"
        special_plugins "${name}"
      fi
      ;;
    */scripts/download_script.php\?src_id=*)
      local name="${repo##*src_id=}"
      local dir="$basedir/$name"
      if [[ ! -d "${dir}" ]] ; then
        mkdir -p "${dir}/plugin/"
        wget -c -O "$dir/plugin/$name.vim" "$repo"
        special_plugins "${name}"
      fi
      ;;
    *.git)
      local name="$(basename ${repo%%.git})"
      local dir="$basedir/$name"
      if [[ -d "$dir/.git" ]] ; then
        echo "vim plugin: Updating $name"
        (
          cd "${dir}"
          local fetch_output=$(  git fetch )
          git reset --hard origin/$(git branch | grep '^\* ' | cut -b 3-)
          git submodule update --init --recursive
          if [[ $fetch_output != "" ]]; then
            special_plugins "${name}"
          fi
        )
      else
        echo "vim plugin: Cloning $name"
        (
          cd "${basedir}" ; git clone "${repo}"
          cd "${dir}" ; git submodule update --init --recursive
          special_plugins "${name}"
        )
      fi
      ;;
  esac
}

purge_vim_plugin() {
  [ -d "$HOME/.vim/bundle/$1" ] && rm -rf "$HOME/.vim/bundle/$1"
}

add_vim_plugin_from_file_list(){
  if [[ ! -f $1 ]]; then
    echo "File '$1' not found." && exit 1
  fi
  for lyn in `cat $1`; do
    if [[ "$lyn" != "" ]]; then
      echo "adding vim plug-in: $lyn"
      add_vim_plugin "$lyn"
    fi
  done
}

#######
### main()

add_vim_plugin_from_file_list "$_VIM_PLUGIN_LIST"

### clean up

unset _VIM_PLUGIN_LIST
unset _VIM_DIR

##### META-INFO of Plug-in Dependencies
# easytags : vim-misc; ctags
# tagbar : easytags; ctags
# vim-marching : neocomplete
# ghcmod-vim : vimproc.vim

