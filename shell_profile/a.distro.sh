#!/usr/bin/env bash

pkg-clean-cache(){
    if [ -f /etc/arch-release ]; then
        echo "ArchLinux: cleaning  /var/cache/pacman/pkg/ of unused packages and versions."
        sudo pacman -Sc
    else
        echo "This distro not suported yet!" && return 1
    fi
}
