#!/usr/bin/env bash

alias journalctl-clean-but-a-day="journalctl --vacuum-time=1d"

alias pacman-clean="sudo pacman -Sc"
pkg-clean-cache(){
    if [ -f /etc/arch-release ]; then
        echo "ArchLinux: cleaning  /var/cache/pacman/pkg/ of unused packages and versions."
        sudo pacman -Sc
    elif [ -f /etc/redhat-release ]; then
        echo "RHEL-Base: cleaning cached packages"
        sduo yum clean packages
    else
        echo "This distro not suported yet!" && return 1
    fi
}

service_log(){
  if [[ $# -eq 1 ]]; then
    journalctl -u "$1" -f
  else
    echo "This shows service logs for systemd handled service.\nSyntax: 'service_log <service-name>'"
  fi
}

copy-file-path(){
  find . -type f -name "*$1*" | clipit
}

pkg-versions(){
  [[ $# -ne 1 ]] && echo "Usage: pkg-versions <pkg-name>" && return 1
  local pkg_name="$1"
  if [ -f '/etc/debian_version' ]; then
    apt-cache madison $pkg_name
  else
    echo "This distro not suported yet!" && return 1
  fi
}

