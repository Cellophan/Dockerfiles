FROM debian:stable

#Inspired from http://github.com/patforna/docker/go-agent
ENV GO_DOWNLOAD_URL http://download01.thoughtworks.com/go/14.1.0/ga/go-agent-14.1.0-18882.deb
ENV GO_SERVER=goserver.example.com
ENV GO_KEY=8974530975390435074350973450975

RUN apt-get update; apt-get install -qy wget java7-runtime-headless procps git
RUN apt-get install -qy vim


RUN wget -qO- https://get.docker.com/ | sh
VOLUME /var/run/docker.sock

RUN wget -O /tmp/go-agent.deb ${GO_DOWNLOAD_URL}
RUN dpkg -i /tmp/go-agent.deb && rm -f /tmp/go-agent.deb

RUN sed -i "s/GO_SERVER=127.0.0.1/GO_SERVER=${GO_SERVER}/" /etc/default/go-agent

#Based on http://www.thoughtworks.com/products/docs/go/current/help/agent_auto_register.html
RUN echo "agent.auto.register.key=${GO_KEY}\n" >/var/lib/go-agent/config/autoregister.properties

RUN echo "#!/bin/bash \nservice go-agent start\ntail -f /var/log/go-agent/*\n" >/start.sh
RUN chmod u+x /start.sh

CMD /start.sh

