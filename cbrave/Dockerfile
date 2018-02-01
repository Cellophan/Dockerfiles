FROM cell/playground
ENV DOCKER_IMAGE="docker.outer.systems/cell/cbrave"
ENV DEFAULT_CMD="brave --no-sandbox"

RUN set -xv &&\
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy curl lsb-release apt-transport-https libasound2 &&\
    curl https://s3-us-west-2.amazonaws.com/brave-apt/keys.asc \
      | apt-key add - &&\
    echo "deb https://s3-us-west-2.amazonaws.com/brave-apt $(lsb_release -sc) main" > /etc/apt/sources.list.d/brave.list &&\
    apt update &&\
    apt install -qy brave

#Material
COPY material/scripts    /usr/local/bin/
COPY material/payload    /opt/payload/

