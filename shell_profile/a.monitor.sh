##################### sysdig ##################################################

alias sysdig-topcontainers-net='sudo sysdig -c topcontainers_net'
alias sysdig-htop='sudo csysdig -pc'

sysdig-k8(){
  if [[ $# -eq 0 ]]; then
    echo "USAGE: sysdig-k8 <KUBERNETES_URI>"
    echo "KUBERNETES_URI need to be K8 API URI similar to 'http://admin:password@127.0.0.1:8080'"
    return
  fi
  local _KUBERNETES_URI="$1"
  sudo csysdig -pc -k "${_KUBERNETES_URI}"
}

acpi-status(){
  local at_time battery temp adapter
  at_time=$(date)
  battery=$(acpi -b | awk '{print $4}')
  temp=$(acpi -t | awk '{print $3,$4}')
  adapter=$(acpi -a | awk '{print $3}')
  echo "[ ${at_time} ] Battery: ${battery} | Temp: ${temp} | Adapter: ${adapter}"
}
