#!/bin/bash
set -e

apt-get update
if [ -f /usr/local/bin/wp ]; then
    apt-get install -y curl
    echo "WP cmd already installed, skipping installation..."
else
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

rm -rf /var/www/html/*
cp -r /usr/src/wordpress/. /var/www/html/
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

cd /var/www/html
/usr/local/bin/wp config create \
    --dbname=wordpress \
    --dbuser=wordpress \
    --dbpass=wordpress_password \
    --dbhost=db \
    --allow-root

/usr/local/bin/wp core install \
    --url=http://localhost:8080 \
    --title="My WordPress Site" \
    --admin_user=admin \
    --admin_password=admin123 \
    --admin_email=admin@example.com \
    --skip-email \
    --allow-root

/usr/local/bin/wp theme install twentytwentythree --activate --allow-root

apache2-foreground 