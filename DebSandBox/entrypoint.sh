#!/bin/bash

set -Eeuo pipefail

stacktrace () { 
  echo "unhandled error. stacktrace:" 
   i=0 
   while caller $i; do 
     i=$((i+1)) 
   done 
}
trap "stacktrace" ERR 

[ ! "${DEBUG:-unset}" == "unset" ] && set -vx

usage() {
  echo "A lot of arguments are needed to start this image. It s recommanded to use an alias:

  alias dsb=\"\$(docker run --rm cell/debsandbox --cmd)\"

  Extra-option:
    For debug: -e DEBUG=1"
}

if [ $# -eq 1 ]; then
  case "$1" in
    --help)
     usage
     exit 0 ;;
    --cmd)
     echo "docker run -ti --rm -w \$PWD -v \$PWD:\$PWD -v /etc/localtime:/etc/localtime:ro -v \$HOME/.ssh:\$HOME/.ssh -e USER=\$USER -e UID=\$(id --user) -e GID=\$(id --group) -v \$SSH_AUTH_SOCK:\$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=\$SSH_AUTH_SOCK -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/.X11-unix:/tmp/.X11-unix cell/debsandbox"
     exit 0 ;;
  esac
fi


if [    $PWD == "/" \
 -o -z "$USER" \
 -o -z "$UID" \
 -o -z "$GID" \
 -o ! -d "/home/$USER/.ssh" \
 -o -z "$SSH_AUTH_SOCK" \
 -o ! -S "$SSH_AUTH_SOCK" \
 -o ! -S /var/run/docker.sock \
 -o ! -d "/tmp/.X11-unix" ]; then
  echo -e "Some arguments are not provided.\n"

  usage

  [ ! "${DEBUG:-unset}" == "unset" ] && exit 1
  #Check making the container to not work
  test $PWD != "/"
  test ! -z "$USER"
  test ! -z "$UID"
  test ! -z "$GID"
  test -d "/home/$USER/.ssh"
  test ! -z "$SSH_AUTH_SOCK"
  test -S "$SSH_AUTH_SOCK"
  test -S /var/run/docker.sock
  test -d "/tmp/.X11-unix"
  exit 1
fi

#Default value
: ${SHELL:="/bin/bash"}
export WORKDIR=$PWD

if [ $(stat -c "%u" /home/${USER}) -eq 0 ]; then
  IS_HOME_MOUNTED=false
else
  IS_HOME_MOUNTED=true
fi
export IS_HOME_MOUNTED

groupadd $USER --gid $GID
useradd  $USER --gid $GID --uid $UID --groups docker

export DISPLAY=:0
export SSH_AUTH_SOCK
export SSH_AUTH_SOCK
export DOCKER_CONTAINER=$(cat /proc/self/cgroup | grep "docker" | sed s/\\//\\n/g | tail -1)
export DOCKER_IMAGE=$(docker inspect -f '{{.Config.Image}}' ${DOCKER_CONTAINER})

for f in /etc/profile.d/* ; do
  source $f
done

echo "$USER ALL = NOPASSWD: ALL" >/etc/sudoers.d/full-sudo
chmod 0440 /etc/sudoers.d/full-sudo

chown ${USER} /home/${USER}

if [ $# -eq 0 ]; then
  exec su $USER --shell $SHELL
else
  #No working perfectly
  exec sudo -E -u $USER $@
fi

