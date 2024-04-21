FROM wordpress:6.5.2-php8.1-fpm-alpine

COPY . /tmp
ENV WORDPRESS_PREPARE_DIR /usr/src/wordpress
RUN chmod 777 /tmp/install.sh && /bin/bash /tmp/install.sh

