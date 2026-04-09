FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Configuración básica de vsftpd
RUN mkdir -p /var/run/vsftpd/empty

# Copiaremos un script de configuración para crear el usuario dinámicamente
COPY ./conf/ftp_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/ftp_setup.sh

# Puertos: 21 para control, 40000-40005 para datos pasivos
EXPOSE 21 40000-40005

ENTRYPOINT ["ftp_setup.sh"]