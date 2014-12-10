wget https://ghost.org/zip/ghost-latest.zip

docker run --rm -ti -p 2368:2368 -v /home/cell/docker/Ghost/external:/external  ghost
