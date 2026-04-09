FROM debian:bookworm

# Install redis server
RUN apt-get update && apt-get install -y \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# Configure Redis to listen on all interfaces and disable protected mode
# This allows the WordPress container to talk to it
RUN sed -i "s/bind 127.0.0.1/bind 0.0.0.0/" /etc/redis/redis.conf

# Run redis in foreground
CMD ["redis-server", "--protected-mode", "no"]