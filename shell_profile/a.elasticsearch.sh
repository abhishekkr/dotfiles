#!/usr/bin/env bash

es-master(){
  local _ES_HOSTNAME="$1"
  curl "http://${_ES_HOSTNAME}:9200/_cat/master?v"
}

es-state(){
  local _ES_HOSTNAME="$1"
  curl "http://${_ES_HOSTNAME}:9200/_cluster/state"
}

es-indices(){
  local _ES_HOSTNAME="$1"
  curl "http://${_ES_HOSTNAME}:9200/_cat/indices?v"
}

es-indices-mb(){
  local _ES_HOSTNAME="$1"
  curl "http://${_ES_HOSTNAME}:9200/_cat/indices?v" | grep -E '[0-9]+mb'
}

es-indices-gb(){
  local _ES_HOSTNAME="$1"
  curl "http://${_ES_HOSTNAME}:9200/_cat/indices?v" | grep -E '[0-9]+gb'
}

es-optimize-expunge(){
  local _ES_HOSTNAME="$1"
  curl -XPOST \
    'http://${_ES_HOSTNAME}:9200/_optimize' \
    -d '{"only_expunge_deletes": true}'
}
