FROM php:8.2-apache

# Cài đặt extension PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql

# Bật mod_rewrite của Apache
RUN a2enmod rewrite

# Cấu hình Apache: cho phép .htaccess và đặt DocumentRoot
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html|g' /etc/apache2/sites-available/000-default.conf \
    && sed -i 's|<Directory /var/www/html>|<Directory /var/www/html>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride All\n\tRequire all granted|g' /etc/apache2/apache2.conf

# Copy toàn bộ source code vào container
COPY . /var/www/html/Quanlymuontrasach

# Đặt quyền cho thư mục
RUN chown -R www-data:www-data /var/www/html/Quanlymuontrasach \
    && chmod -R 755 /var/www/html/Quanlymuontrasach

# Tạo index mặc định ở root để redirect
RUN echo '<?php header("Location: /Quanlymuontrasach/frontend/login.html"); exit; ?>' > /var/www/html/index.php

EXPOSE 80
