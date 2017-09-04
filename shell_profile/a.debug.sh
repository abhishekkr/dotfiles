
strace-vim(){
  strace $CMD 2>&1 > /dev/null | vim -c ':set syntax=strace' -
}
