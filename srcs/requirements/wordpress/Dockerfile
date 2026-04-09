FROM debian:bookworm

# Instala PHP-FPM, MariaDB-client can check conection and  wget/curl
RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Download wp-cli (configutarion code line tool for WordPress)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp


RUN mkdir -p /run/php && mkdir -p /var/www/wordpress

# change PHP-FPM config to lisent 9000 port (not local socket)
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/wordpress

ENTRYPOINT ["/usr/local/bin/setup.sh"]