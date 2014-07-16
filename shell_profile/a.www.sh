#!/usr/bin/env bash

## WEB API sorts

x-rates(){
  _AMOUNT=$1
  _FROM_CURRENCY=$2
  _TO_CURRENCY=$3
  if [[ -z $_FROM_CURRENCY ]]; then
    _FROM_CURRENCY="USD"
  fi
  if [[ -z $_TO_CURRENCY ]]; then
    _TO_CURRENCY="INR"
  fi
  _XRATES_URL="http://www.x-rates.com/calculator/?from=${_FROM_CURRENCY}&to=${_TO_CURRENCY}&amount=${_AMOUNT}"

  echo "Converting ${_FROM_CURRENCY} to ${_TO_CURRENCY}..."
  _tmp_data_stage01=`curl -sLk "$_XRATES_URL" | sed 's/</\n/g' | grep -E 'ccOutputRslt|ccOutputTrail|ccOutputCode' | sed 's/.*>//g'`
  _CONVERTED_AMOUNT=`echo $_tmp_data_stage01 | awk '{print $1$2,$3}'`

  echo "${_AMOUNT} ${_FROM_CURRENCY} ~= ${_CONVERTED_AMOUNT}"
  unset _AMOUNT
  unset _FROM_CURRENCY
  unset _TO_CURRENCY
  unset _XRATES_URL
  unset _tmp_data_stage01
  unset _CONVERTED_AMOUNT
}
