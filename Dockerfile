FROM ubuntu:latest

MAINTAINER Mike paxton (https://github.com/mikepaxton)

ENV LANG=C.UTF-8 DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

COPY scripts /var/spool/apt-mirror/

###  Set local repository  ###
RUN echo \
 && apt-get -q -y update \
 && apt-get -q -y full-upgrade \
 && apt-get -q -y install apt-mirror \
                          wget \
                          nginx \
                          cron \
                          nano \
                          curl \
                          xz-utils \
 && apt-get -q -y clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && mv /etc/apt/mirror.list /etc/apt/mirror.list.default \
 && mv /var/spool/apt-mirror/mirror.list /etc/apt/mirror.list \
 && mv /var/spool/apt-mirror/apt-mirror-site-enabled /etc/nginx/sites-enabled/apt-mirror.conf \
 && mv /var/spool/apt-mirror/apt-mirror /usr/bin/apt-mirror \
 && chmod +x /usr/bin/apt-mirror \
 && mv /var/spool/apt-mirror/apt-mirror.cron /etc/cron.d/apt-mirror \
 && chmod +x /var/spool/apt-mirror/timestamp.sh \
 && echo Finished.



EXPOSE 81

VOLUME ["/var/spool/apt-mirror"]

ENTRYPOINT ["/var/spool/apt-mirror/entrypoint.sh"]
