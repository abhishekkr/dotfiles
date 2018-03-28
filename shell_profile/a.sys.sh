
how-many-cores(){
  grep -c "^processor" /proc/cpuinfo
}

set-swappiness(){
  local VM_SWAPPINESS="$1" ## how much memory left before start to swap

  [[ -z "${VM_SWAPPINESS}" ]] && VM_SWAPPINESS=15
  echo "vm.swappiness = ${VM_SWAPPINESS}" | sudo tee -a /etc/sysctl.conf
}
