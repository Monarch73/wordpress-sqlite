#!/bin/bash
echo "sed'ing www.conf to use ondemand pm"
sed -i 's/pm = dynamic/pm = ondemand/g' /usr/local/etc/php-fpm.d/www.conf

echo "installing curl and unzip"
apk add --update curl unzip

echo "clear cache"
rm -Rf /var/cache/apk/*


echo "download Sqlite integration plugin"
curl -o /tmp/wpplugin.zip https://downloads.wordpress.org/plugin/sqlite-database-integration.zip

echo "unzip Sqlite integration plugin"
unzip /tmp/wpplugin.zip -d /usr/src/wordpress/wp-content/plugins/

echo "removing zip file"
rm /tmp/wpplugin.zip

echo "setting up wp-config.php"
cp /usr/src/wordpress/wp-content/plugins/sqlite-integration/db.php /usr/src/wordpress/wp-content


echo "copying wp-config.php"
cp config/wp-config.php /var/www/wp-config.php

echo "chown wp-config.php"
chown www-data:www-data /var/www/wp-config.php
