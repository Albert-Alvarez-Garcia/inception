#!/bin/bash
set -e

# 1. Wait for MariaDB to be ready
until mysqladmin ping -h"mariadb" --silent; do
    echo "WordPress: Waiting for MariaDB..."
    sleep 3
done

# 2. WordPress installation & configuration
if [ ! -f "wp-config.php" ]; then
    echo "WordPress: Starting first-time installation..."

    wp core download --allow-root

    wp config create \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306 \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email \
        --allow-root

    echo "WordPress: Creating second user..."
    wp user create \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author \
        --allow-root
fi

# ---------------------------------------------------------
# REDIS BONUS CONFIGURATION
# ---------------------------------------------------------
echo "WordPress: Configuring Redis bonus..."

# Set Redis host and port in wp-config.php if not already there
wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --allow-root
wp config set WP_CACHE true --raw --allow-root

# Install and enable the Redis Object Cache plugin
# We use --force to ensure it updates if necessary
wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root
# ---------------------------------------------------------

# Ensure correct ownership
chown -R www-data:www-data /var/www/wordpress

# 3. Start PHP-FPM in foreground
echo "WordPress: Initializing PHP-FPM..."
exec php-fpm8.2 -F