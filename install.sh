#!/bin/bash
#echo "sed'ing www.conf to use ondemand pm"
#sed -i 's/pm = dynamic/pm = ondemand/g' /usr/local/etc/php-fpm.d/www.conf

# insert line "exec nginx" before a line containing 'exec "$@"' in /usr/local/bin/docker-entrypoint.sh using sed
sed -i '/exec "$@"/i exec nginx' /usr/local/bin/docker-entrypoint.sh

echo "installing curl and unzip"
apk add --update curl unzip
apk add nginx

echo "clear cache"
rm -Rf /var/cache/apk/*


echo "download Sqlite integration plugin"
curl -o /tmp/wpplugin.zip https://downloads.wordpress.org/plugin/sqlite-database-integration.zip

echo "unzip Sqlite integration plugin"
unzip /tmp/wpplugin.zip -d /usr/src/wordpress/wp-content/plugins/

echo "removing zip file"
rm /tmp/wpplugin.zip

echo "setting up wp-config.php"
cp /usr/src/wordpress/wp-content/plugins/sqlite-database-integration/wp-includes/sqlite/db.php /usr/src/wordpress/wp-content
cp /tmp/default.conf /etc/nginx/http.d/default.conf

echo "copying wp-config.php"
cp /tmp/config/wp-config.php /var/www/wp-config.php

echo "chown wp-config.php"
chown www-data:www-data /var/www/wp-config.php
