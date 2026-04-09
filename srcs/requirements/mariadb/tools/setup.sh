#!/bin/bash
set -e

# 1. Ensure directories exist and have correct permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# 2. Configure MariaDB to listen on all network interfaces
# This allows connection from the WordPress container
sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mariadb.conf.d/50-server.cnf

# 3. Initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/${SQL_DATABASE}" ]; then

    # Initialize MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily in the background to set up users
    # We use mysqld_safe directly as 'service' doesn't work well in Docker
    /usr/bin/mysqld_safe --datadir='/var/lib/mysql' &
    
    # Wait for the server to be ready
    until mysqladmin ping >/dev/null 2>&1; do
        echo "MariaDB: Setting up users..."
        sleep 1
    done

    # Security and user configuration using .env variables
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
    mysql -u root -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
    mysql -u root -e "FLUSH PRIVILEGES;"

    # Shut down the temporary server
    mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
fi

# 4. Launch MariaDB in the foreground
echo "MariaDB: Starting server in foreground..."
exec mysqld_safe --datadir='/var/lib/mysql'
