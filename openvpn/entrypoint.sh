#!/bin/sh

set -e

[ -d /dev/net ] || mkdir -p /dev/net
[ -c /dev/net/tun ] || mknod /dev/net/tun c 10 200

REMOTE=$(grep ^remote *ovpn | cut -d\  -f2)
GATEWAY=$(ip route get 8.8.8.8 | grep via | sed 's/.*via \([.0-9]*\) .*/\1/')

ip route add ${REMOTE} via ${GATEWAY}
ip route del default
ip route add prohibit default
#echo 1 > /proc/sys/net/ipv4/ip_forward

exec openvpn --config *.ovpn

