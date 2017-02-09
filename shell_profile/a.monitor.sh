##################### sysdig ##################################################

alias monitor-sysdig-topcontainers-net='sudo sysdig -c topcontainers_net'
alias sysdig-topcontainers-net='monitor-sysdig-topcontainers-net'

alias monitor-sysdig-htop='sudo csysdig -pc'
alias sysdig-htop='monitor-sysdig-htop'

monitor-sysdig-k8(){
  if [[ $# -eq 0 ]]; then
    echo "USAGE: sysdig-k8 <KUBERNETES_URI>"
    echo "KUBERNETES_URI need to be K8 API URI similar to 'http://admin:password@127.0.0.1:8080'"
    return
  fi
  local _KUBERNETES_URI="$1"
  sudo csysdig -pc -k "${_KUBERNETES_URI}"
}
alias sysdig-k8="monitor-sysdig-k8"

monitor-acpi-status(){
  local at_time battery temp adapter
  at_time=$(date --rfc-3339='seconds')
  battery=$(acpi -b | awk '{print $4}')
  temp=$(acpi -t | awk '{print $3,$4}')
  adapter=$(acpi -a | awk '{print $3}')
  echo "[ ${at_time} ] Battery: ${battery} | Temp: ${temp} | Adapter: ${adapter}"
}
alias acpi-status="monitor-acpi-status"


##################### valgrind #################################################

monitor-valgrind-massif(){
  valgrind --tool=massif $@
  local massif_files=$(ls -laht | grep massif.out | awk '{print $9}' | head -1)
  echo "lookout for massif.out.\* files created at ${PWD}"
  echo "can use following to vizualize recordings\n\'\$ massif-visualizer ${massif_files}\'"
}



##################### pmap #################################################

alias monitor-pmapd="pmap -d"
alias monitor-pmapx="pmap -x"
alias monitor-pmapxx="pmap -XX"


###############################################################################

