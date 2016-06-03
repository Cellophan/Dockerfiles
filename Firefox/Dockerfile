FROM cell/debsandbox
MAINTAINER Cell <maintainer.docker.cell@outer.systems>
ENV	DOCKER_IMAGE="cell/firefox"

ENV DEFAULT_CMD="iceweasel"
RUN	apt-get update &&\
	apt-get install -qy iceweasel &&\
	apt-get clean -y && rm -rf /var/lib/apt/lists/*

ADD material/scripts	/usr/local/bin/


