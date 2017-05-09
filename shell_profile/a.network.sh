
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

chk-net-ssh(){
  mtr --tcp -P22 $@
}

chk-net-dns(){
  mtr --tcp -P53 $@
}
