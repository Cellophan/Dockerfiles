FROM debian
RUN apt update &&\
    apt install -qy openvpn
COPY material/entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

