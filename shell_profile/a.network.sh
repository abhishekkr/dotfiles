
alias ipaddr="ifconfig | grep 'inet ' | awk '{print \$2}'"
alias ports='netstat -tulanp'
alias check-net='curl --silent -Ik google.com || mtr --tcp -P53 8.8.8.8'
alias check-http='curl -LkI www.google.co.in'
alias check-ping='ping -c10 8.8.8.8'

alias ip-ls-bridge="ip link show type bridge"
alias ip-ls-bond="ip link show type bond"
alias ip-ls-dummy="ip link show type dummy"
alias ip-ls-veth="ip link show type veth"
alias ip-ls-vlan="ip link show type vlan"

ls-wifi(){
  nmcli dev wifi list
}

ls-conn(){
  nmcli con
}

chk-net-ssh(){
  mtr --tcp -P22 $@
}

chk-net-dns(){
  mtr --tcp -P53 $@
}

is-private-ip(){
  local NODE_IP="$1"

  local PRIV_LO="^127\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
  local PRIV_24="^10\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
  local PRIV_20="^192\.168\.\d{1,3}.\d{1,3}$"
  local PRIV_16="^172.(1[6-9]|2[0-9]|3[0-1]).[0-9]{1,3}.[0-9]{1,3}$"

  local IS_PRIVATE=1
  [[ $(echo ${NODE_IP} | grep -c -P "${PRIV_LO}") -eq 1 ]] && IS_PRIVATE=0
  [[ $(echo ${NODE_IP} | grep -c -P "${PRIV_24}") -eq 1 ]] && IS_PRIVATE=0
  [[ $(echo ${NODE_IP} | grep -c -P "${PRIV_20}") -eq 1 ]] && IS_PRIVATE=0
  [[ $(echo ${NODE_IP} | grep -c -P "${PRIV_16}") -eq 1 ]] && IS_PRIVATE=0

  [[ "${IS_PRIVATE}" -eq 0 ]] && return 0
  return 1
}

net-conn-established(){
  netstat -an | grep EST | awk '{print $5}' | cut -d ":" -f1 | xargs -I{} nslookup {} | grep name | awk '{print $4}' | cut -d "." -f1 | sort | uniq
}
alias conn-est="net-conn-established"

net-conn-listen(){
   sudo lsof -i | grep LISTEN
}
conn-srv(){
  sudo lsof -i -P | grep LISTEN | awk '{print "process:",$1,"| pid:",$2,"| listen-at:",$9}'
}


net-conn-all(){
   sudo lsof -i | grep ESTABLISHED | awk '{print $9}' | sed 's/\->/\n/g' | sort | uniq -c | grep -v ' '$(hostname)'\:' | grep -v ' 127.0.0.1\:'
}

net-conn-all-uniq(){
   sudo lsof -i | grep ESTABLISHED | awk '{print $9}' | sed 's/\->/\n/g'| awk -F':' '{print $1}'  | sort | uniq | grep -v ' '$(hostname)'\:' | grep -v ' 127.0.0.1\:'
}
conn-all(){
  net-conn-all-uniq
}

dnsg(){
  local _NAME="$1"
  curl -skL https://dns.google.com/resolve\?name\=${_NAME}\&type\=A | jq ".Answer[].data" | xargs
}

net-neighbors(){
  ip neigh show
}

tcpdump-http(){
  local _HTTP_PORT="${1:-80}"
  echo "sudo tcpdump -i any -A -s 0 'tcp port ${_HTTP_PORT} and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'"
  eval "sudo tcpdump -i any -A -s 0 'tcp port ${_HTTP_PORT} and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'"
}
