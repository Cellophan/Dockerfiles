FROM cell/playground
ENV DOCKER_IMAGE="cell/cbt"
ENV DEFAULT_CMD=bitcoin-qt

RUN apt update &&\
    apt install -qy software-properties-common &&\
    add-apt-repository --yes ppa:bitcoin/bitcoin &&\
    apt update &&\
    apt install -qy bitcoin-qt

#Material
COPY material/scripts    /usr/local/bin/
COPY material/payload    /opt/payload/

ENV QT_X11_NO_MITSHM 1
#RUN apt install -qy firefox
