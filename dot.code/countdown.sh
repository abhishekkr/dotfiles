#!/usr/bin/env bash

export TXT_PREFIX="/tmp/abhishekkr_bash_counter_txt_"


read -d '\n' txt_begin << EndOfTextBegin
 .---
| .--
| |  
| |  
| |  
| |  
| |  
| |  
| |  
| '--
 '---
EndOfTextBegin

read -d '\n' txt_end << EndOfTextEnd
---. 
--. |
  | |
  | |
  | |
  | |
  | |
  | |
  | |
--' |
---' 
EndOfTextEnd

read -d '\n' txt_1 << EndOfText1
----------
----------
   ___    
  /   |   
  '-| |   
    | |   
  __| |_  
 |______| 
          
----------
----------
EndOfText1

read -d '\n' txt_2 << EndOfText2
-----------
-----------
  ______   
 /_,___ '. 
   .___) | 
  /'____.' 
 / /____   
 |_______| 
           
-----------
-----------
EndOfText2

read -d '\n' txt_3 << EndOfText3
-----------
-----------
   _____   
  /____ '. 
      _) | 
  _  |_ '. 
 | '___) | 
  [_____.' 
           
-----------
-----------
EndOfText3

read -d '\n' txt_4 << EndOfText4
-----------
-----------
  _    _   
 | |  | |  
 | |__| |, 
 |____  ,| 
      | |  
     |___| 
           
-----------
-----------
EndOfText4

read -d '\n' txt_5 << EndOfText5
-----------
-----------
  ______   
 |  ____|  
 | |___    
 ''.___''. 
 ,-,___) | 
  '_____.' 
           
-----------
-----------
EndOfText5

read -d '\n' txt_6 << EndOfText6
------------
------------
   ______   
 /' ____.]  
 | |    ''  
 | '====-,  
 | (____) ) 
  '______/  
            
------------
------------
EndOfText6

read -d '\n' txt_7 << EndOfText7
-----------
-----------
 ,_______  
 |  ___  | 
 |_/  / /  
     / /   
    / /    
   /_/     
           
-----------
-----------
EndOfText7

read -d '\n' txt_8 << EndOfText8
-----------
-----------
    ___    
  .' _ '.  
  | (_) |  
  .'___'.  
 | (___) | 
 '._____.' 
           
-----------
-----------
EndOfText8

read -d '\n' txt_9 << EndOfText9
-----------
-----------
   _____   
  / ___ '  
 ( (___) | 
  '.___. | 
  .,___| | 
  ]_____,' 
           
-----------
-----------
EndOfText9

read -d '\n' txt_0 << EndOfText0
-----------
-----------
    ___    
  .'   '.  
 |  .-.  | 
 | (   ) | 
 |  '-'  | 
  '.___.'  
           
-----------
-----------
EndOfText0


## to prepare file list args for numbers more than single digit
num_to_files(){
  local count="$1"
  local file_list="${TXT_PREFIX}end"
  while [[ $count -gt 0 ]];
  do
    local LASTDIGIT=$(($count % 10))
    file_list="${TXT_PREFIX}${LASTDIGIT} ${file_list}"
    count=$(($count / 10))
  done
  echo -n "${TXT_PREFIX}begin ${file_list}"
}

run_counter(){
  local BEGIN="$1"
  local END="$2"
  local COUNTDOWN_SLEEP="$3"

  for count in `seq $BEGIN -1 $END`
  do
    clear
    if [[ $count -lt 10 ]]; then
      paste -d "" "${TXT_PREFIX}begin" "${TXT_PREFIX}${count}" "${TXT_PREFIX}end"
    else
      paste -d "" $(num_to_files $count)
    fi
    sleep $COUNTDOWN_SLEEP
  done
}


################ PREPARE
#
echo "$txt_begin" > "${TXT_PREFIX}begin"
echo "$txt_end" > "${TXT_PREFIX}_end"
echo "$txt_1" > "${TXT_PREFIX}1"
echo "$txt_2" > "${TXT_PREFIX}2"
echo "$txt_3" > "${TXT_PREFIX}3"
echo "$txt_4" > "${TXT_PREFIX}4"
echo "$txt_5" > "${TXT_PREFIX}5"
echo "$txt_6" > "${TXT_PREFIX}6"
echo "$txt_7" > "${TXT_PREFIX}7"
echo "$txt_8" > "${TXT_PREFIX}8"
echo "$txt_9" > "${TXT_PREFIX}9"
echo "$txt_0" > "${TXT_PREFIX}0"


################ MAIN

[[ $# -lt 1 ]] && \
  echo "usage: $0 <countdown-from-number> [<countdown-to-number:0> <sleep-intervals:0.125s>]" && \
  exit 123

run_counter "$1" "${2:-0}" "${3:-1s}"
