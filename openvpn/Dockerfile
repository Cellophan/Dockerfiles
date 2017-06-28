FROM debian
RUN apt update &&\
    apt install -qy openvpn
COPY entrypoint.sh /
COPY update-resolv-conf /etc/openvpn/
ENTRYPOINT ["/entrypoint.sh"]

