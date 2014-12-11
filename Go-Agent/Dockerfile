FROM debian:stable

#Inspired from http://github.com/patforna/docker/go-agent
ENV GO_DOWNLOAD_URL http://download01.thoughtworks.com/go/14.1.0/ga/go-agent-14.1.0-18882.deb
ENV GO_KEY 8974530975390435074350973450975

#Those two env variableis can be overwritten at runtime (with --link or --env)
ENV GO_SERVER goserver.example.com
ENV GO_SERVER_PORT 8153

RUN apt-get update; apt-get install -qy wget java7-runtime-headless procps git

RUN wget -qO- https://get.docker.com/ | sh

RUN wget -O /tmp/go-agent.deb ${GO_DOWNLOAD_URL}
RUN dpkg -i /tmp/go-agent.deb && rm -f /tmp/go-agent.deb

RUN sed -i '/.*GO_SERVER.*/d' /etc/default/go-agent
RUN sed -i '/.*GO_SERVER_PORT.*/d' /etc/default/go-agent

#Based on http://www.thoughtworks.com/products/docs/go/current/help/agent_auto_register.html
RUN echo "agent.auto.register.key=${GO_KEY}\n" >/var/lib/go-agent/config/autoregister.properties

#Embedding start script in Dockerfile
RUN echo "#!/bin/bash -e\n\
  [ ! -e /var/run/docker.sock ] && echo "/var/run/docker.sock is not mounted. You need -v /var/run/docker.sock:/var/run/docker.sock" && exit 1\n\
  service go-agent start\n\
  tail -f /var/log/go-agent/*\n\
  " >/start.sh
RUN chmod u+x /start.sh

CMD /start.sh
