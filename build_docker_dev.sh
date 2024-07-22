#!/bin/bash

IMAGE_NAME="auditory-almanac"
COMMIT_HASH=$(git rev-parse --short HEAD)
TIMESTAMP=$(date +%Y%m%d-%H%M)

docker build -t ${IMAGE_NAME}:${COMMIT_HASH}-${TIMESTAMP} .

if [ $? -eq 0 ]; then
    echo "Docker image for development built successfully: ${IMAGE_NAME}:${COMMIT_HASH}-${TIMESTAMP}"
else
    echo "Error: Docker build failed"
    exit 1
fi