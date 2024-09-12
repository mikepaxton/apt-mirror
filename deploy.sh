#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs -0)
fi

# Perform the copy operation
cp -r "./scripts/." "$STORAGE_DIR"
sudo chmod +x "$STORAGE_DIR"/*.sh
sudo chown www-data:www-data "$STORAGE_DIR"/*
mv "$STORAGE_DIR/sites-enabled_default" "$NGINX_SITE_ENABLED_DIR/apt-mirror.conf"
# Start docker-compose build and up
docker compose up --build
