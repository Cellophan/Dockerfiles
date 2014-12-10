#FROM    debian:7
FROM ubuntu
RUN apt-get update
RUN apt-get -qy install python g++ make checkinstall fakeroot sqlite3 wget
RUN src=$(mktemp -d) && cd $src; \
  wget -N http://nodejs.org/dist/node-latest.tar.gz; \
  tar xzvf node-latest.tar.gz && cd node-v*; \
  ./configure; \
  fakeroot checkinstall -y --install=no --pkgversion $(echo $(pwd) | sed -n -re's/.+node-v(.+)$/\1/p') make -j$(($(nproc)+1)) install; \
  dpkg -i node_*

# Bundle app source
RUN mkdir /app
WORKDIR /app
ENV NODE_ENV production
# Install app dependencies
RUN apt-get -qy install git unzip
RUN wget -P /tmp/ https://ghost.org/zip/ghost-latest.zip
RUN \
  unzip /tmp/ghost-latest.zip -d /app && \
  rm -f /tmp/ghost-latest.zip && \
  cd /app && \
  npm install --production && \
  sed 's/127.0.0.1/0.0.0.0/' /app/config.example.js > /app/config.js && \
  useradd app --home /app

RUN apt-get -qy install facter
COPY start.sh /start.sh
EXPOSE 2368
CMD ["/start.sh"]
VOLUME ['/external']

