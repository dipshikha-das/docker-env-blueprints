# Customizable Docker Environment Setup Template for ROS Developments

💡 This repository provides a simple ros docker setup template for working with different ros distros, packages and includes configurations for building a docker, setting up environment variables, and managing dependencies.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [Environment Setup](#environment-setup)
  - [Package Setup](#package-dependent-setup)
  - [Build and run](#how-to-build-and-run)
  - [Testing with ros distros](#testing)
  - [Feedback & Contributions](#-contributefeedback-to-the-project)

## Prerequisites

Before you begin, ensure you have the following installed:

| Dependencies | Version |
| ------------- | ------------- |
| [Docker Install Guide](https://docs.docker.com/get-docker/) | ![docker ](https://img.shields.io/badge/docker-27.4.1-brightgreen)


## Setup Instructions

### Environment Setup
> [!IMPORTANT]
> The current stable version and actively maintained branch of the repository is the **`ros-any`** branch. Please ensure you are using this branch for your setup. Other branches may contain experimental or in-progress features.

1. Clone the repository to your local machine:

    ```bash
    git clone <repository-url>
    git checkout ros-any
    cd docker-env-blueprints
    ```
### Package Dependent Setup

The project uses Docker to encapsulate the ROS Distro environment. It is flexible to include the base ROS Distro image and the necessary dependencies are all configurable from the following files:

1. **Update the Docker image**:

    ```bash
    vi Dockerfile
    ```
    - Update the argument ```ARG BASE_IMAGE ``` to the desired image.
    - This will use the image mentioned as the base.

2. **Update environment variables**:

    - The `.env` file contains all the environment varibles for the Docker setup which are then referenced in the `docker-compose.yaml`.

| Parameter | Usage |
| ------------- | ------------- |
|`CONTAINER_NAME`| To set the container's name|
|`IMAGE_NAME`| To set the Docker image name to use or build|
|`HOST_HOME`| Defines the path to load files and packages from the host system|
|`LOCAL_WORKSPACE`| Defines the path from which the packages can be mounted to the docker|
|`APT_PACKAGES`| Set the list of packages that will be apt installed in the docker while build |
|`PACKAGE_REQUIREMENTS_PATHS`| Path to `/deps/requirements.txt` which lists the packages for python pip install |
|`ROS_IMAGE_VERSION`| Can be set to either `1` or `2` based on which the bashrc is updated and build commands are executed accordingly |
|`HOST_IP_ADD`| Set the host IP address for loading the DDS or HOSTNAME configurations accordingly|

> [!IMPORTANT]
> Update the `.env` file to ensure the build params are configured correctly.

```bash
vi .env
```
- Updated the parameters with user defined configuratons.

3. **Docker Compose Setup**

* The `docker-compose.yaml` utilizes the parameters defined in the `.env` file.
> [!NOTE]
> No changes are required if the default configuration is used(Default setup with **`ros-noetic`** base image)

4. **.sh & .txt file setup**

| File | Utility |
| ------------- | ------------- |
|`requirements.txt`| Lists all the packages required to be installed while docker setup|
|`install_requirments.sh` | Install the required dependencies from the parameters defined in the `.env` file| 
|`ros_entrypoint.sh`| Setup and execute the ros commands for source and build on docker compose|

> [!NOTE]  
> Only the `requirements.txt` will require modifications based on the required packages to be installed.

### How to build and run

```shell
    
#Build the container
#The args `--no-cache` and `--progess=plain` can be used to freshly build and check details logs respectively.
docker compose build --no-cache --progress=plain

#Start the container
#This will start the containers in the background.

docker compose up -d

#Running packages inside the container
#If display is required execute `xhost +` before running the above command.

docker exec -it <container_name> /bin/bash

#Stopping the container

docker-compose down
```

* The above commands are embedded in the `run-docker.sh` script and can be executed by supplying the conatiner name set in the `.env` file as the `CONTAINER_NAME` env variable.

```bash
./run-docker.sh <container_name>
```

> [!NOTE]
> All the commands above are executed inside the `docker-env-blueprints` folder.

## Testing
* The following setups have been tested and validated using this package and can be expanded further.

| Distro | Test Status  |
| --- | --- |
| ROS 1 Noetic (u20.04) | ![status](https://img.shields.io/badge/validated-brightgreen)|
| ROS 2 Humble (u22.04) | ![status](https://img.shields.io/badge/validated-brightgreen)|

### 👩‍💻 Contribute/Feedback to the project

If you want to contribute or share feedback on the project, feel free to create PRs or open discussions or issues.
