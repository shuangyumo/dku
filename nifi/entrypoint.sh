#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  # move all repo to /data as well as flows
  sed -i -e 's~=./\([a-z]*\)_repository~=/data/\1_repository~g' conf/nifi.properties
  sed -i -e 's~=./conf/flow.xml.gz~=/data/conf/flow.xml.gz~' conf/nifi.properties
  sed -i -e "s/nifi.web.http.port=.*/nifi.web.http.port=${VIRTUAL_PORT}/" conf/nifi.properties
  sed -i -e "s/nifi.sensitive.props.key=.*/nifi.sensitive.props.key=password/" conf/nifi.properties
  sed -i -e "s~nifi.web.proxy.context.path=.*~nifi.web.proxy.context.path=/nifi~" conf/nifi.properties

  HEAP_SIZE=${HEAP_SIZE:-512m}
  sed -i -e "s/java.arg.2=-Xms.*/java.arg.2=-Xms${HEAP_SIZE}/" conf/bootstrap.conf
  sed -i -e "s/java.arg.3=-Xmx.*/java.arg.3=-Xmx${HEAP_SIZE}/" conf/bootstrap.conf
  touch .setup
}
export -f _setup #debug

function _start {
  _setup
  exec nifi.sh run
}

case $1 in
  start) _start;;
  *)       exec $@;;
esac

