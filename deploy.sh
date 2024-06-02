#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs -0)
fi

# Perform the copy operation
cp -r "./scripts/." "$STORAGE_DIR"
sudo chmod +x "$STORAGE_DIR"/*.sh
# Start docker-compose build and up
docker compose up --build
