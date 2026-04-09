# Use Debian Bookworm
FROM debian:bookworm

# Install PHP and wget
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-mysql \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create directory and download Adminer
WORKDIR /var/www/html
RUN wget "https://www.adminer.org/latest.php" -O index.php

# Start PHP built-in server on port 8080
# (Simple and effective for this bonus)
CMD ["php", "-S", "0.0.0.0:8080", "index.php"]