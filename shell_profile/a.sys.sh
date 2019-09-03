
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
