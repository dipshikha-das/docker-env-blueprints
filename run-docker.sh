# ==============================================================================
# Copyright (c) 2025 Dipshikha Das
# All rights reserved. This script is licensed under the MIT License.
#
# Description: This script executes the sequence of commands to run the docker.
#
# Author: Dipshikha Das
# Version: 1.0
# Date: 2025-01-09
# ==============================================================================

#!/bin/bash

sudo docker compose build --no-cache --progress=plain
sudo docker compose up -d
xhost +
sudo docker exec -it $1 /bin/bash
