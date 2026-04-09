#!/bin/bash

# Crear el usuario FTP con las variables de entorno
adduser $FTP_USER --disabled-password --gecos ""
echo "$FTP_USER:$FTP_PWD" | chpasswd

# Cambiar el dueño de la carpeta de wordpress (opcional pero recomendado)
chown -R $FTP_USER:$FTP_USER /var/www/wordpress

# Configuración mínima de vsftpd.conf
cat << EOF > /etc/vsftpd.conf
listen=YES
local_enable=YES
write_enable=YES
local_umask=022
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_enable=YES
pasv_min_port=40000
pasv_max_port=40005
pasv_address=127.0.0.1
secure_chroot_dir=/var/run/vsftpd/empty
EOF

echo "FTP: Started on port 21 for user $FTP_USER"
exec vsftpd /etc/vsftpd.conf