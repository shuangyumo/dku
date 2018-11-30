#!/bin/bash

function _setup {
  [[ -f .setup ]] && return
  sed -i -e 's/^#jobmanager.web.address:.*/jobmanager.web.address: 0.0.0.0/' conf/flink-conf.yaml
  if [[ $HEAP == low ]]; then 
    sed -i -e 's/heap.size: 1024m/heap.size: 256m/g' conf/flink-conf.yaml
  fi
  touch .setup
}


function _start {
  _setup
  # load the env
  . /opt/flink/bin/config.sh
  TMSlaves start
  exec bin/jobmanager.sh start-foreground
  
}

export -f _setup _start

case $1 in
  start) _start;;
  *)       exec $@;;
esac

