FROM cell/playground
ENV DOCKER_IMAGE="cell/cff"
ENV DEFAULT_CMD=firefox

RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy firefox &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Material
COPY material/scripts    /usr/local/bin/
COPY material/payload    /opt/payload/

