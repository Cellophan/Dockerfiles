#!/bin/bash
set -e

CONF_DIR="${PWD}/conf"

exec docker run --rm -ti \
  -v ${CONF_DIR}:${CONF_DIR}:ro -w ${CONF_DIR} \
  --cap-add NET_ADMIN --cap-add MKNOD \
  --name ovpn \
  cell/openvpn

