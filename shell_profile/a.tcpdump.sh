
tcpdump-elasticsearch(){
  [[ -z "${TCPDUMP_PACKET_COUNT}" ]] && TCPDUMP_PACKET_COUNT=30
  [[ -z "${TCPDUMP_NIC}" ]] && TCPDUMP_NIC=any
  [[ -z "${ELASTICSEARCH_PORT}" ]] && ELASTICSEARCH_PORT=9300
  sudo tcpdump -c ${TCPDUMP_PACKET_COUNT} -A -nn -s 0 "tcp dst port ${ELASTICSEARCH_PORT} and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)" -i ${TCPDUMP_NIC}
}
