#!/usr/bin/bash

_VIM_BUNDLE="$HOME/.vim/bundle"
cd $_VIM_BUNDLE

clone_if_missing(){
  cd $_VIM_BUNDLE
  if [[ ! -d "$1" ]]; then
    git clone "$2" "$1" 
  fi
}

clone_if_missing "${_VIM_BUNDLE}/vim-go" "https://github.com/fatih/vim-go.git"
clone_if_missing "${_VIM_BUNDLE}/vim-gocode" "https://github.com/Blackrush/vim-gocode"

clone_if_missing "${_VIM_BUNDLE}/ack.vim" "https://github.com/mileszs/ack.vim'
#Plugin 'msanders/snipmate.vim'
clone_if_missing "${_VIM_BUNDLE}/YouCompleteMe" "https://github.com/Valloric/YouCompleteMe.git"

clone_if_missing "${_VIM_BUNDLE}/vim-powerline" "https://github.com/Lokaltog/vim-powerline.git"

# My Bundles
#Plugin 'scrooloose/nerdtree'


YCM_COMPLETE_PATH="$HOME/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so"
if [[ ! -f "$YCM_COMPLETE_PATH" ]]; then
  cd "${_VIM_BUNDLE}/YouCompleteMe/"
  git submodule update --init --recursive
  bash -ic ./install.sh --clang-completer --system-clang
else
  echo "YCM is installed."
fi

cd $_VIM_BUNDLE
