#!/bin/bash

IMAGE_NAME="auditory-almanac"
COMMIT_HASH=$(git rev-parse --short HEAD)
TIMESTAMP=$(date +%Y%m%d-%H%M)

docker build -t ${IMAGE_NAME}:${COMMIT_HASH}-${TIMESTAMP} .

if [ $? -eq 0 ]; then
    echo "Docker image for development built successfully: ${IMAGE_NAME}:${COMMIT_HASH}-${TIMESTAMP}"
    SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
    docker run -e SECRET_KEY=${SECRET_KEY} -p 80:80 ${IMAGE_NAME}:${COMMIT_HASH}-${TIMESTAMP}
else
    echo "Error: Docker build failed"
    exit 1
fi