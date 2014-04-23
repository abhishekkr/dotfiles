#!/usr/bin/env bash
### quick utils for DVB-T + DAB + FM


### Play FM Radio of provided frequency
rdo-fm-play(){
  if [ $# -ne 1 ]; then echo "Usage: radio_fm <FREQ>" && return 1; fi
  _FREQ=$1
  rtl_fm -M wbfm -f ${_FREQ}M | play -r 32k -t raw -e signed-integer -b 16 -c 1 -V1 -
}


## Play Mumbai FM stations
fm-mumbai(){
    _Frequencies=("91.1 92.7 93.5 94.3 98.3 100.7 104.0 104.8 107.1")
    _Station_Names=("Radio-City BIG-FM Red-FM Radio-One Radio-Mirchi AIR-FM-Gold Fever Oye-FM AIR-FM-Rainbow")
    for _FREQ in $_Frequencies; do
        echo $_FREQ
    done
    unset _Frequencies
    unset _Station_Names
    unset _FREQ
}

