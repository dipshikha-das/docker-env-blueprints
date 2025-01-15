#!/bin/bash

# Exit on error
set -xe
echo "Running install_requirements.sh"

# Source the configuration file to load environment variables
if [ -f /.env  ]; then
  echo "Sourcing the env file"
  source /.env 
else
  echo ".env  file not found!"
  exit 1
fi

# Install APT packages if APT_PACKAGES is defined
if [ -n "$APT_PACKAGES" ]; then
  echo "Installing APT packages: $APT_PACKAGES"
  apt-get update
  apt-get install -y $APT_PACKAGES
  # rm -rf /var/lib/apt/lists/*
  # apt-get clean
else
  echo "No APT packages to install!"
fi


# Check if PACKAGE_REQUIREMENTS_PATHS is defined
if [ -z "$PACKAGE_REQUIREMENTS_PATHS" ]; then
  echo "Error: PACKAGE_REQUIREMENTS_PATHS is not defined in .env !"
fi

# Loop over the paths in PACKAGE_REQUIREMENTS_PATHS and install dependencies
IFS=":" # Set delimiter to colon (:) to separate the paths

# Debugging: Show the paths to be installed
echo "Installing from the following requirements files:"
for REQUIREMENTS_PATH in $PACKAGE_REQUIREMENTS_PATHS
do
  echo "- $REQUIREMENTS_PATH"
done

# Install dependencies for each specified requirements.txt file
for REQUIREMENTS_PATH in $PACKAGE_REQUIREMENTS_PATHS
do
  # Prepend the base directory to the relative paths
  FULL_PATH="$REQUIREMENTS_PATH"

  # Check if the file exists
  if [ -f "$FULL_PATH" ]; then
    echo "Installing from ($FULL_PATH)..."
    pip3 install -r "$FULL_PATH"
  else
    echo "Warning: $FULL_PATH not found. Skipping..."
  fi
done
python3 -m pip install --upgrade pip

echo "All dependencies installed."
