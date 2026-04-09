FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

# Copiamos nuestra web al directorio de nginx
COPY ./conf/index.html /var/www/html/index.html
COPY ./conf/style.css /var/www/html/style.css

# Configuración básica de Nginx para servir en el puerto 1337 (por ejemplo)
RUN echo "server { \
    listen 1337; \
    root /var/www/html; \
    index index.html; \
    location / { try_files \$uri \$uri/ =404; } \
}" > /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]