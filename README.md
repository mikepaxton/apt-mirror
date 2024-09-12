# apt-mirror

This repository sets up a local APT mirror using Docker, leveraging a modified `apt-mirror` binary that addresses several known issues. This setup is particularly useful for environments that require offline access to package repositories.

*This repository is a spin off of an excellent docker container made by [gregewing/apt-mirror](https://hub.docker.com/r/gregewing/apt-mirror).  I've made a couple of modifications to fudnction better with using a Raspberry Pi as the server.*

## Purpose

The purpose of this repository is to create a local APT mirror using Docker. This setup is ideal for scenarios where systems need to operate without a reliable internet connection, allowing for continued installations and updates of software packages from a local source.

## Features

- **Patched `apt-mirror`**: Fixes common issues with i18n translation errors in Raspberry Pi and Debian mirrors.
    Here is a link the to patched apt-mirror file for reference:  https://launchpad.net/~likemartinma/+archive/ubuntu/apt-mirror/+packages
- **Enhanced Logging**: Includes timestamps in cron logs for better tracking.
    */usr/bin/apt-mirror 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log /var/spool/apt-mirror/var/clean.sh 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log*
- **Scheduled Updates**: Mirrors repositories during off-peak hours to avoid bandwidth issues.


## Included Software in the container

- `wget`: For downloading files.
- `nginx`: To serve the mirrored repository.
- `cron`: To schedule daily updates.
- `xz-utils`: For handling `.xz` compressed files.
- `apt-mirror`: To mirror APT repositories.

## Setup

- Ensure that Docker and Docker Compose are installed and configured on your system before running the script.
- Modify the script according to your specific requirements, such as adjusting file paths (.env) or adding additional commands.
- Always review the script and test it in a development environment before using it in a production environment.
- You will find the file mirror.list in the scripts directory. Before deploying apt-mirror, you will want to modify the file for the repositories you wish to mirror.
- You can modify when cron runs to keep your repositories up-to-date by modifying apt_mirror.cron in the scripts folder.


## Docker Compose file

Include the following in your `docker-compose.yml`:

```yaml
services:
  apt-mirror:
    build: .
    container_name: apt-mirror
    volumes:
      - ${STORAGE_DIR}:/var/spool/apt-mirror
    ports:
      - "80:80"
    environment:
      - NGINX_HOST=localhost
      - NGINX_PORT=80
    restart: unless-stopped
```

## Accessing the APT Mirror
Configure your systems to use the local mirror by pointing to the NGINX_HOST and NGINX_PORT specified in the Docker Compose file.

### Notes:
Ensure the apt-mirror container has network access to reach upstream APT repositories.
Adjust configuration files and environment variables as needed for your specific setup.
By following these instructions, you can set up a local APT mirror using Docker.

## Docker Deployment Script
File: deploy.sh

```sh
#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs -0)
fi

# Perform the copy operation
cp -r "./scripts/." "$STORAGE_DIR"
sudo chmod +x "$STORAGE_DIR"/*.sh
mv "$STORAGE_DIR/sites-enabled_default" "$NGINX_SITE_ENABLED_DIR/apt-mirror.conf"

# Start docker-compose build and up
docker compose up --build

```

This deploy script automates the deployment process for a Dockerized application. It loads environment variables from a `.env` file, copies scripts to a specified directory, makes all `.sh` files executable, and then starts the Docker containers using `docker compose up --build`.

## Usage

1. Place the `.env` file containing environment variables in the same directory as the script.

2. Ensure that the necessary scripts are located in a directory named `scripts` within the current directory.

3. Run the script using the following command:

    ```bash
    /deploy.sh
    ```

## Script Explanation

- **Load Environment Variables**: The script loads environment variables from the `.env` file using `export $(grep -v '^#' .env | xargs -0)`. This allows configuration of the deployment environment.

- **Copy Operation**: It copies the contents of the `scripts` directory to a directory specified by `$STORAGE_DIR`.

- **Set File Permissions**: The script makes all `.sh` files within the `$STORAGE_DIR` directory executable using `sudo chmod +x "$STORAGE_DIR"/*.sh`.

- **Docker Compose**: Finally, it starts building the image and Docker container using `docker compose up --build`.
*I purposely left the -d (detach command out) so you can monitor the building process to make sure everything goes well*

## Future Configuring

You will find the mirror.list at the location you chose for your volume - /data/www/html/apt-mirror:/var/spool/apt-mirror.  After you edit this file, you will need to restart the container for the changes to take effect.
```sh
docker compose restart apt-mirror
```
## Starting apt-mirror without building
Once the image and container have been built using ./deploy.sh, you can start docker normally by using:
*NOTE: Before running the following you will need to edit the docker-compose.yml file and comment out the " build: ." line and save the file.*
*Not doing so will cause docker compose up to rebuild the container.*
```yaml
#Build: .
```
Now run:
```sh
docker compose up -d
```

If you need to edit the cron job use:

- docker exec -it apt-mirror bash
- nano /etc/cron.d/apt-mirror.cron



