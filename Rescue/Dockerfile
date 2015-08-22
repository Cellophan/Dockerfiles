FROM debian:stable

RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy sudo vim git curl jq strace htop top openssh-client tcpdump net-tools dnsutils &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

