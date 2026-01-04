#!/bin/bash

xhost +

# current folder as WORD_DIR
CURRENT_DIR=$(pwd)

set -eo pipefail

sudo docker run -itd --name robotwin \
--gpus all \
--rm \
--network=host \
--privileged \
--shm-size=8g \
--entrypoint /root/workspace/main/docker/entrypoint.sh \
-e NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
-v ${CURRENT_DIR}:/root/workspace/main \
robotwin:latest