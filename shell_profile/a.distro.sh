#!/usr/bin/env bash

alias journalctl-clean-but-a-day="journalctl --vacuum-time=1d"

alias pacman-clean="sudo pacman -Sc"
pkg-clean-cache(){
    if [ -f /etc/arch-release ]; then
        echo "ArchLinux: cleaning  /var/cache/pacman/pkg/ of unused packages and versions."
        sudo pacman -Sc
    elif [ -f /etc/redhat-release ]; then
        echo "RHEL-Base: cleaning cached packages"
        sudo yum clean packages
    else
        echo "This distro not suported yet!" && return 1
    fi
}

pkg-update-sequential(){
    if [ -f /etc/arch-release ]; then
        echo "ArchLinux: updating sequentially."
        echo "WIP"
    elif [ -f /etc/redhat-release ]; then
        echo "RHEL-Base: updating packages sequentially."
        rpm -qa | xargs -I{} sudo dnf -y update {}
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

ubuntu-map-version(){
  local grep_pattern="$1"

  local version_map=$(
    echo "17.04,zesty-zapus,stretch/sid"
    echo "16.10,yakkety-yak,stretch/sid"
    echo "16.04,xenial-xerus,stretch/sid"
    echo "15.10,wily-werewolf,jessie/sid"
    echo "15.04,vividi-vervetsid"
    echo "14.10,utopic-unicorn,jessie/sid"
    echo "14.04,trusty-tahr,jessie/sid"
    echo "13.10,saucy-salamandar,wheezy/sid"
    echo "13.04,raring-ringtall,wheezy/sid"
    echo "12.10,quantal-quetzal,wheezy/sid"
    echo "12.04,precise-pangolin,wheezy/sid"
    echo "11.10,oneiric-ocelot,wheezy/sid"
    echo "11.04,nattynarwhal,squeeze/sid"
    echo "10.10,maverick-meerkat,squeeze/sid"
    echo "10.04,lucid-lynx,squeeze/sid"
  )

  for version in $(echo $version_map); do
    [[ $(echo $version | grep -i -c "${grep_pattern}") -ne 0 ]] && echo $version
  done
}
