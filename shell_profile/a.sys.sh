
how-many-cores(){
  grep -c "^processor" /proc/cpuinfo
}
