#! /bin/bash

# This is bashtime.sh
# Copyright (c) 2013 Paul Scott-Murphy

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

alias hardware-time="sudo /usr/bin/hwclock --localtime"
alias hardware-time-to-distro="sudo /usr/bin/hwclock --hctosys --localtime"
alias hardware-time-from-distro="sudo /usr/bin/hwclock --systohc --localtime"

alias epoch-now="date +%s"
epoch-to-time(){
  local _EPOCH=$1
  local EPOCH=$_EPOCH
  if [[ $_EPOCH -gt 10000000000 ]]; then # some have *1000
    EPOCH=$(($_EPOCH/1000)) ## will stop working post 2286
  fi
 date -d @${EPOCH} +"%d-%m-%Y %T %z"
}

time=`date +%I%M`;
if [ "$time" -lt 115 ]
then
    export CLOCK_SYMBOL='🕐'
elif [ "$time" -lt 145 ]
then
    export CLOCK_SYMBOL='🕜'
elif [ "$time" -lt 215 ]
then
    export CLOCK_SYMBOL='🕑'
elif [ "$time" -lt 245 ]
then
    export CLOCK_SYMBOL='🕝'
elif [ "$time" -lt 315 ]
then
    export CLOCK_SYMBOL='🕒'
elif [ "$time" -lt 345 ]
then
    export CLOCK_SYMBOL='🕞'
elif [ "$time" -lt 415 ]
then
    export CLOCK_SYMBOL='🕓'
elif [ "$time" -lt 445 ]
then
    export CLOCK_SYMBOL='🕟'
elif [ "$time" -lt 515 ]
then
    export CLOCK_SYMBOL='🕔'
elif [ "$time" -lt 545 ]
then
    export CLOCK_SYMBOL='🕠'
elif [ "$time" -lt 615 ]
then
    export CLOCK_SYMBOL='🕕'
elif [ "$time" -lt 645 ]
then
    export CLOCK_SYMBOL='🕡'
elif [ "$time" -lt 715 ]
then
    export CLOCK_SYMBOL='🕖'
elif [ "$time" -lt 745 ]
then
    export CLOCK_SYMBOL='🕢'
elif [ "$time" -lt 815 ]
then
    export CLOCK_SYMBOL='🕗'
elif [ "$time" -lt 845 ]
then
    export CLOCK_SYMBOL='🕣'
elif [ "$time" -lt 915 ]
then
    export CLOCK_SYMBOL='🕘'
elif [ "$time" -lt 945 ]
then
    export CLOCK_SYMBOL='🕤'
elif [ "$time" -lt 1015 ]
then
    export CLOCK_SYMBOL='🕙'
elif [ "$time" -lt 1045 ]
then
    export CLOCK_SYMBOL='🕥'
elif [ "$time" -lt 1115 ]
then
    export CLOCK_SYMBOL='🕚'
elif [ "$time" -lt 1145 ]
then
    export CLOCK_SYMBOL='🕦'
elif [ "$time" -lt 1215 ]
then
    export CLOCK_SYMBOL='🕛'
elif [ "$time" -lt 1300 ]
then
    export CLOCK_SYMBOL='🕛'
else
    export CLOCK_SYMBOL='⭕'
fi

clock(){
  echo $CLOCK_SYMBOL"  :  "`date`
}
