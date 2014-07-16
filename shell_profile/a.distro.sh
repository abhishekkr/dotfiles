#!/usr/bin/env bash

pkg-clean-cache(){
    if [ -f /etc/arch-release ]; then
        echo "ArchLinux: cleaning  /var/cache/pacman/pkg/ of unused packages and versions."
        sudo pacman -Sc
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
