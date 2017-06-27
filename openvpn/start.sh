#!/bin/bash

set_client_pbr() {
  echo
}

check_client_network() {
  echo
  #docker network --driver local vpn_client
}

start_vpn() {
  CONF_DIR="${PWD}/conf"
  docker run --rm -ti \
    -v ${CONF_DIR}:${CONF_DIR}:ro -w ${CONF_DIR} \
    --cap-add NET_ADMIN --cap-add MKNOD \
    cell/openvpn
}

main() {
  start_vpn
}

main $@
