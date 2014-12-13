[Ghost blog] (https://ghost.org/)
===========
Node and ghost are downloaded in them latest versions of course without compatibility checks.

# Build the image
```
docker built -t ghost .
```
# Persistence
## Extract the default data from a launched container
```
mkdir external
docker cp <container id>:/app/content/data external/
docker cp <container id>:/app/content/images external/
docker cp <container id>:/app/content/themes external/
docker cp <container id>:/app/config.js external/
```
## Launch
```
docker run --rm -ti -p 2368:2368 -v ${PWD}/external:/external  ghost
```
