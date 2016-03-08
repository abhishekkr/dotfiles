## net/sec

gen-secure(){
  openssl rand -base64 512 | tr -d '\r\n' | tee "$1"
}

nohistry(){
  export HISTFILE=/dev/null
}

my-public-ip(){
  local _MY_PUBLIC_IP=$( curl "https://www.google.co.in/search?q=my+ip&oq=my+ip&aqs=chrome..69i57.1205j0j1&sourceid=chrome&es_sm=0&ie=UTF-8" 2>/dev/null | grep -E -o '\(Client IP address: [0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*\)' | grep -E -o '([0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*)' )
  if [[ "${_MY_PUBLIC_IP}" == "" ]]; then
    echo "ERROR: Not able to reach internet (www.google.co.in)."
  else
    export ABK_MY_PUBLIC_IP="${_MY_PUBLIC_IP}"
    echo "Public IP: ${ABK_MY_PUBLIC_IP}"
  fi
}
alias ipaddr-public="my-public-ip"

nmap-xtreme(){
  sudo nmap -p 1-65535 -sS -sU -T4 -A -vvvv -Pn -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script "default or (discovery and safe)" -oA "nmap-$1" $1
}
