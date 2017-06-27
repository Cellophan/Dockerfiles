FROM debian
RUN apt update &&\
    apt install -qy openvpn
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

