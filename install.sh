#!/bin/bash
#echo "sed'ing www.conf to use ondemand pm"
#sed -i 's/pm = dynamic/pm = ondemand/g' /usr/local/etc/php-fpm.d/www.conf

# insert line "exec nginx" before a line containing 'exec "$@"' in /usr/local/bin/docker-entrypoint.sh using sed
sed -i '/exec "$@"/i nginx' /usr/local/bin/docker-entrypoint.sh

echo "installing curl and unzip"
apk add --update curl
apk add nginx

echo "clear cache"
rm -Rf /var/cache/apk/*


echo "download Sqlite integration plugin"
curl -L -o /tmp/sqlite-database-integration.tar.gz "https://github.com/WordPress/sqlite-database-integration/archive/refs/tags/v2.1.9.tar.gz"

echo "untar Sqlite integration plugin"
tar zxvf sqlite-database-integration.tar.gz -c /tmp/

#install
mkdir -p /usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration 
cp -r /tmp/sqlite-database-integration/* /usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration/
mv "/usr/src/wordpress/wp-content/mu-plugins/sqlite-database-integration/db.copy" "/usr/src/wordpress/wp-content/db.php"
sed -i 's#{SQLITE_IMPLEMENTATION_FOLDER_PATH}#/var/www/html/wp-content/mu-plugins/sqlite-database-integration#' "/usr/src/wordpress/wp-content/db.php"
sed -i 's#{SQLITE_PLUGIN}#sqlite-database-integration/load.php#' "/usr/src/wordpress/wp-content/db.php"
mkdir "/usr/src/wordpress/wp-content/database"
touch "/usr/src/wordpress/wp-content/database/.ht.sqlite"
chmod 640 "/usr/src/wordpress/wp-content/database/.ht.sqlite"

echo "removing tar file"
rm /tmp/sqlite-database-integration.tar.gz

echo "setting up wp-config.php"
#cp /usr/src/wordpress/wp-content/plugins/sqlite-database-integration/wp-includes/sqlite/db.php /usr/src/wordpress/wp-content
cp /tmp/config/default.conf /etc/nginx/http.d/default.conf

#echo "copying wp-config.php"
#cp /tmp/config/wp-config.php /usr/src/wordpress/wp-config.php

#echo "chown wp-config.php"
#chown www-data:www-data /var/www/wp-config.php
