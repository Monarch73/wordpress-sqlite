FROM wordpress:6.5.2-php8.1-fpm-alpine

COPY . /tmp
RUN chmod 777 /tmp/install.sh && /bin/bash /tmp/install.sh

