# This Dockerfile builds a base image - mentioned here ros-noetic
# It uses the full desktop image, installs dependencies defined in .env and requirements.txt, and sets up the application.

# UserDefined: Set the base image 
ARG BASE_IMAGE=osrf/ros:noetic-desktop-full
# ARG BASE_IMAGE=osrf/ros:humble-desktop-full

# Generic code starts here
FROM ${BASE_IMAGE}
ARG USER=user
ARG DEBIAN_FRONTEND=noninteractive

# Install generic packages
RUN apt-get update && apt-get install -y \
    git \
    vim \
    sudo \
    curl \
    wget \
    && apt-get clean

# Copy and install required packages
COPY deps/requirements.txt /deps/
COPY .env /

COPY install_requirements.sh /
RUN chmod +x /install_requirements.sh
RUN /install_requirements.sh

RUN mkdir -p /ros_ws/src
WORKDIR /ros_ws

COPY ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["bash"]
