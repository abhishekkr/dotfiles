#!/usr/bin/env bash

export DOT_OHMYZSH="${HOME}/.oh-my-zsh"
[[ ! -d "${DOT_OHMYZSH}" ]] && \
  echo "[ERROR] oh-my-zsh is yet not installed; skipping Extra Setup" && \
  exit 123

git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

pip install --user poetry
