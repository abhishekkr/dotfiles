
check-secure-boot(){
  mokutil --sb-state
}

how-many-cores(){
  grep -c "^processor" /proc/cpuinfo
}

set-swappiness(){
  local VM_SWAPPINESS="$1" ## how much memory left before start to swap

  [[ -z "${VM_SWAPPINESS}" ]] && VM_SWAPPINESS=15
  echo "vm.swappiness = ${VM_SWAPPINESS}" | sudo tee -a /etc/sysctl.conf
}

hwtime(){
  sudo hwclock -r
}

hwclock-to-os(){
  sudo hwclock --hctosys
}

os-to-hwclock(){
  sudo hwclock --systohc
}

ls-input-devices(){
  sudo libinput list-devices | grep '^Device:' | awk -F':' '{print $2}' | sed 's/^\s*/\*\ /g'
}

ls-io-schedulers(){
  for blockPath in $(ls -d /sys/block/*); do
    echo -n $(basename "${blockPath}")": "
    cat "${blockPath}/queue/scheduler"
  done
}

mem-rss(){
  local PROCNAME="${1:-bash}"
  ps -ylC ${PROCNAME} --sort:rss
}

purge-caches-cmds(){
  echo "pip cache purge"
  echo "pnpm store prune"
  echo "tracker3 reset -s -r"
}

chmod-fix-dir(){
  local _this_dir="${1:-.}"
  find "${_this_dir}" -type f | xargs -I{} chmod 0755 "{}"
}

chmod-fix(){
  local _this_dir="${1:-.}"
  find "${_this_dir}" -perm 777 -type d | xargs -I{} chmod 0775 "{}"
  find "${_this_dir}" -perm 777 -type f | xargs -I{} chmod 0755 "{}"
}

chown-fix(){
  local _this_dir="${1:-.}"
  local PERM_STR="${USER}"
  if [[ -z "${USER}" ]]; then
    echo "[ERROR:MISSING] user: ${USER}"
    return 123
  fi
  if [[ -z "${GROUP}" ]]; then
    echo "[WARNING:MISSING] group: ${GROUP}"
    PERM_STR="${USER}:${GROUP}"
  fi
  find "${_this_dir}" -nouser -type d | xargs -I{} sudo chown ${PERM_STR} "{}"
  find "${_this_dir}" -nouser -type f | xargs -I{} sudo chown ${PERM_STR} "{}"
  find "${_this_dir}" -user 0 -type d | xargs -I{} sudo chown ${PERM_STR} "{}"
  find "${_this_dir}" -user 0 -type f | xargs -I{} sudo chown ${PERM_STR} "{}"
}

check-kernel(){
  local PKGS=$(rpm -qa | grep -i '^kernel-[0-9]' | sed 's/kernel-//')
  export OLD_IFS="${IFS}"
  export IFS=
  echo $PKGS | while read -r kver; do
    [[ -z "${kver}" ]] && next
    if [[ -f "/boot/initramfs-${kver}.img" ]]; then
      echo "[INFO] initramfs for kernel-$kver exists."
    else
      echo "[ERROR] initramfs for kernel-$kver is missing."
      echo "Solution: Run 'sudo dracut -f --kver ${kver}'"
      return 123
    fi
  done
  export IFS="${OLD_IFS}"
}
