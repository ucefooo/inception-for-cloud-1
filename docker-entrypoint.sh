#!/bin/bash
set -e

echo "Installing WP-CLI..."
apt-get update
apt-get install -y less curl
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp-cli
ln -s /usr/local/bin/wp-cli /usr/local/bin/wp

echo "Copying WordPress files..."
rm -rf /var/www/html/*
cp -r /usr/src/wordpress/. /var/www/html/

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Creating wp-config.php..."
cd /var/www/html
/usr/local/bin/wp config create \
    --dbname=wordpress \
    --dbuser=wordpress \
    --dbpass=wordpress_password \
    --dbhost=mysql \
    --allow-root

echo "Installing WordPress..."
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