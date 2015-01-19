nmapxtreme(){
  sudo nmap -p 1-65535 -sS -sU -T4 -A -vvvv -PE -PP -PS80,443 -PA3389 -PU40125 -PY -g 53 --script "default or (discovery and safe)" -oA "nmap-$1" $1
}
