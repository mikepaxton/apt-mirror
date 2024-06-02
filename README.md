# apt-mirror

This repository sets up a local APT mirror using Docker, leveraging a modified `apt-mirror` binary that addresses several known issues. This setup is particularly useful for environments that require offline access to package repositories.

*This repository is a spin off of an excellent docker container made by [gregewing/apt-mirror](https://hub.docker.com/r/gregewing/apt-mirror).  I've made a couple of modifications to function better with using a Raspberry Pi as the server.*

## Purpose

The purpose of this repository is to create a local APT mirror using Docker. This setup is ideal for scenarios where systems need to operate without a reliable internet connection, allowing for continued installations and updates of software packages from a local source.

## Features

- **Patched `apt-mirror`**: Fixes common issues with i18n translation errors in Raspberry Pi and Debian mirrors.
    Here is a link the to patched apt-mirror file for reference:  https://launchpad.net/~likemartinma/+archive/ubuntu/apt-mirror/+packages
- **Enhanced Logging**: Includes timestamps in cron logs for better tracking.
    */usr/bin/apt-mirror 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log /var/spool/apt-mirror/var/clean.sh 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log*
- **Scheduled Updates**: Mirrors repositories during off-peak hours to avoid bandwidth issues.


## Included Software

- `wget`: For downloading files.
- `nginx`: To serve the mirrored repository.
- `cron`: To schedule daily updates.
- `xz-utils`: For handling `.xz` compressed files.
- `apt-mirror`: To mirror APT repositories.

## Setup



### Docker Compose

Include the following in your `docker-compose.yml`:

```yaml
services:
  apt-mirror:
    build: .
    container_name: apt-mirror
    volumes:
      - /data/www/html/apt-mirror:/var/spool/apt-mirror
    ports:
      - "80:80"
    environment:
      - NGINX_HOST=localhost
      - NGINX_PORT=80
    restart: unless-stopped
```

## Building the Docker Image
Ensure your Dockerfile builds the necessary image with all configurations.

## Running the apt-mirror
To start the service, navigate to the directory containing your docker-compose.yml and run:

```sh
docker-compose up -d --build
```

## Accessing the APT Mirror
Configure your systems to use the local mirror by pointing to the NGINX_HOST and NGINX_PORT specified in the Docker Compose file.

### Notes:
Ensure the apt-mirror container has network access to reach upstream APT repositories.
Adjust configuration files and environment variables as needed for your specific setup.
By following these instructions, you can set up a local APT mirror using Docker.




*/usr/bin/apt-mirror 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log /var/spool/apt-mirror/var/clean.sh 2>&1 | /var/spool/apt-mirror/timestamp.sh >> /var/spool/apt-mirror/var/cron.log*

I've chosen not to use Managed Bandwidth as I let apt-mirror run in the middle of the night.


## Deploying:

I've included both a Dockerfile and docker-compose.yml file. It's best to make the changes to both apt-mirror.cron and mirror.list which can be found in the scripts folder before building the container. 


## Configuring:

You will find the mirror.list at the location you chose for your volume - apt-mirror-config:/var/spool/apt-mirror.  After you edit this file, you will need to restart the container for the changes to take effect.

If you need to edit the cron job use:

- docker exec -it apt-mirror bash
- nano /etc/cron.d/apt-mirror.cron


