#!/bin/sh

set -e

[ -d /dev/net ] ||
	mkdir -p /dev/net
[ -c /dev/net/tun ] ||
	mknod /dev/net/tun c 10 200

echo 1 > /proc/sys/net/ipv4/ip_forward

exec openvpn --config *.ovpn

