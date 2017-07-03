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
  : sudo ip route add default via $IP table ${ROUTING_TABLE} &>/dev/null
  echo "Route created"
  sudo ip rule add from ${CIDDR} lookup ${ROUTING_TABLE}
  echo "Rule created"
}

get_vpn_ciddr() {
  if ! $(docker network inspect ${NETWORK_NAME} &>/dev/null); then
    echo "Creating network"
    docker network create --driver=bridge ${NETWORK_NAME}
  else
    echo "Network already existing"
  fi

  CIDDR=$(docker network inspect -f '{{ range .IPAM.Config }}{{.Subnet}}{{end}}' ${NETWORK_NAME})
  echo "vpn CIDDR: ${CIDDR}"

}

start_ovpn() {
  CONF_DIR="${PWD}/conf"
  CONTAINER_ID=$(docker run --detach --rm -ti \
    -v ${CONF_DIR}:${CONF_DIR}:ro -w ${CONF_DIR} \
    --cap-add NET_ADMIN --cap-add MKNOD \
	--name vpn-gw \
	cell/openvpn)
  echo "Openvpn startd"
  IP=$(docker inspect -f '{{.NetworkSettings.Networks.bridge.IPAddress}}' ${CONTAINER_ID})
  echo "vpn-gw ip: ${IP}"
}

allow_traffic() {
  vpn_net=$(get_net 'vpn')

  vpn_gw_ip=$(get_ip 'vpn')
  bridge_gw_ip=$(get_ip 'bridge')
  vpn_intf=$(get_intf $vpn_gw_ip)
  bridge_intf=$(get_intf $bridge_gw_ip)

  echo "Creating iptables rules"
  : sudo iptables -F VPN
  sudo iptables -N VPN
  sudo iptables -A VPN -i $vpn_intf -o $bridge_intf -j ACCEPT
  sudo iptables -A VPN -i $bridge_intf -o $vpn_intf -j ACCEPT
  sudo iptables -A VPN -i $vpn_intf -o $vpn_intf -j ACCEPT
  sudo iptables -A VPN -i $bridge_intf -o $bridge_intf -j ACCEPT

  sudo iptables -I FORWARD -j VPN

  echo "Adding route for trafic back from the vpn-gw"
  docker exec vpn-gw ip route add $vpn_net via $bridge_gw_ip
}

get_net() {
  name=$1
  docker network inspect -f '{{range .IPAM.Config }}{{ .Subnet }}{{end}}' $name
}

get_ip() {
  name=$1
  docker network inspect -f '{{range .IPAM.Config }}{{ .Gateway }}{{end}}' $name
}

get_intf() {
  network=${1:-empty}
  #ip route get ${network} | grep dev | sed 's#^.*dev \([-0-9a-zA-Z]*\) .*$#\1#'
  ip addr show | grep ${network} | sed 's#^.*scope [a-z]* \([-:a-zA-Z0-9]*\)$#\1#'
}

main() {
  start_ovpn
  get_vpn_ciddr
  set_client_pbr
  allow_traffic

  docker logs ${CONTAINER_ID}
  docker attach ${CONTAINER_ID}
}

main $@

#vpn_net=$(get_net 'vpn')
#
#vpn_gw_ip=$(get_ip 'vpn')
#bridge_gw_ip=$(get_ip 'bridge')
#echo vpn_intf=$(get_intf $vpn_gw_ip)
#echo bridge_intf=$(get_intf $bridge_gw_ip)
