#!/bin/bash
set -e

#On exit
#sudo ip route flush table 42

: ${NETWORK_NAME:="vpn"}
: ${ROUTING_TABLE:=42}
: ${IP=""}
: ${CONTAINER_ID=""}
: ${CIDDR=""}

set_client_pbr() {
  sudo ip route add default  via $IP metric 10 table ${ROUTING_TABLE}
  sudo ip route add prohibit default metric 20 table ${ROUTING_TABLE}
  sudo ip rule add from ${CIDDR} lookup ${ROUTING_TABLE}
}

get_vpn_ciddr() {
  if ! $(docker network inspect ${NETWORK_NAME}) &>/dev/null; then
    docker network create --driver=bridge ${NETWORK_NAME}
  fi

  CIDDR=$(docker network inspect -f '{{ range .IPAM.Config }}{{.Subnet}}{{end}}' ${NETWORK_NAME})

}

start_ovpn() {
  CONF_DIR="${PWD}/conf"
  CONTAINER_ID=$(docker run --detach --rm -ti \
    -v ${CONF_DIR}:${CONF_DIR}:ro -w ${CONF_DIR} \
    --cap-add NET_ADMIN --cap-add MKNOD \
	cell/openvpn)
  IP=$(docker inspect -f '{{.NetworkSettings.Networks.bridge.IPAddress}}' ${CONTAINER_ID})
}

main() {
  start_ovpn
  get_vpn_ciddr
  set_client_pbr
  docker attach ${CONTAINER_ID}
}

main $@
