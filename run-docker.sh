#!/bin/bash

sudo docker compose build --no-cache --progress=plain
sudo docker compose up -d
xhost +
sudo docker exec -it $1 /bin/bash
