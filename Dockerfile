#FROM wordpress:fpm
FROM wordpress:fpm-alpine

COPY . /tmp
WORKDIR /tmp
RUN sh /tmp/install.sh

# Pm ondemand to save RAM

VOLUME ["/var/www/db"]
