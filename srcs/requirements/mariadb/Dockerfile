FROM debian:bookworm

#update & install MariaDB
RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

#create folders & get permissions
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

#copy config script
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/setup.sh"]