json_me(){
  bash -c $@ | python -mjson.tool
}

pjson_me(){
  bash -c $@ | pjson
}
