#!/bin/bash

set -e

# Function to set up the ROS environment
setup_ros_environment() {
  echo "Setting up the ROS environment..."
  source "/opt/ros/$ROS_DISTRO/setup.bash"

  if [ -z "$ROS_IMAGE_VERSION" ]; then
    ROS_IMAGE_VERSION=1
    echo "ROS_IMAGE_VERSION is not set. Defaulting to 1."
  fi

  if [[ "$ROS_IMAGE_VERSION" =~ ^[0-9]+$ ]] && [ "$ROS_IMAGE_VERSION" -eq 1 ]; then
    echo 'export ROS_MASTER_URI=http://$HOST_IP_ADD:11311' >> ~/.bashrc && \
    echo 'export ROS_HOSTNAME=$HOST_IP_ADD' >> ~/.bashrc && \
    echo 'export ROS_IP=$HOST_IP_ADD' >> ~/.bashrc
  else
    echo 'export ROS_DOMAIN_ID=0' >> ~/.bashrc && \
    echo 'export CYCLONEDDS_PEER_ADDRESSES=$HOST_IP_ADD' >> ~/.bashrc && \
    echo 'export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp' >> ~/.bashrc && \
    echo 'export CYCLONEDDS_URI=~/.ros/cyclonedds.xml' >> ~/.bashrc
  fi

  echo 'source /opt/ros/$ROS_DISTRO/setup.bash' >> ~/.bashrc && \
  echo 'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc
  
}

# Function to build the workspace
build_workspace() {
  echo "Building the workspace..."
  if [[ "$ROS_IMAGE_VERSION" =~ ^[0-9]+$ ]] && [ "$ROS_IMAGE_VERSION" -eq 1 ]; then
    catkin_make
  else
    colcon build
  fi
}

# Function to source the workspace setup if it exists
source_workspace() {
  echo "Sourcing workspace setup..."
  if [[ "$ROS_IMAGE_VERSION" =~ ^[0-9]+$ ]] && [ "$ROS_IMAGE_VERSION" -eq 1 ]; then
    if [ -f "/ros_ws/devel/setup.bash" ]; then
      source "/ros_ws/devel/setup.bash"
    else
      echo "Workspace setup file not found!"
    fi
  else
    if [ -f "/ros_ws/install/setup.bash" ]; then
      source "/ros_ws/install/setup.bash"
    else
      echo "Workspace setup file not found!"
    fi
  fi
}

# Function to execute the command passed to the Docker container
exec_in_docker() {
  if [ -n "$1" ]; then
    echo "Executing command: $1"
    exec "$@"
  else
    echo "No command provided, starting a default behavior."
    # You can set a default command, like launching a ROS node or shell
    # For example, launching a ROS core:
    # roslaunch my_package my_launch_file.launch
  fi
}

# Main execution flow
setup_ros_environment
build_workspace
source_workspace
exec_in_docker "$@"
