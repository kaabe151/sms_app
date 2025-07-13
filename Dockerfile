FROM php:8.2-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    sqlite3 libsqlite3-dev libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_mysql zip gd mbstring bcmath

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy application
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Laravel specific setup
RUN php artisan config:cache

CMD php artisan serve --host=0.0.0.0 --port=8000
