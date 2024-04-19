#!/bin/bash

# Configuration
dataDir="/path/on/host"  # Directory on the host for persistent data storage
image="dorowu/ubuntu-desktop-lxde-vnc"
hostPort="8080"
containerPort="80"
vncPort="5900"
containerName="desktop_container"
SESSION_DIR="/data/in/container"

# Function to stop and remove the old container
stop_and_remove_container() {
    echo "Checking for existing container..."
    containerId=$(docker ps -aqf "name=$containerName")

    if [ -n "$containerId" ]; then
        echo "Stopping and removing old container..."
        docker stop "$containerId" >/dev/null 2>&1
        docker rm "$containerId" >/dev/null 2>&1
    fi
}

# Function to start a new container
start_new_container() {
    echo "Starting a new container..."
    docker run -d \
        -p "$hostPort:$containerPort" \
        -p "$vncPort:$vncPort" \
        --name "$containerName" \
        -v "$dataDir:$SESSION_DIR" \
        "$image"
}

# Stop and remove the old container
stop_and_remove_container

# Start a new container
start_new_container

echo "New container started successfully."
