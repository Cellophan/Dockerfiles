FROM cell/playground
ENV DOCKER_IMAGE="cell/ctransmission"
ENV DEFAULT_CMD=transmission-gtk

RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy transmission-gtk &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Material
COPY material/scripts    /usr/local/bin/
COPY material/payload    /opt/payload/

