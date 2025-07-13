FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    libpq-dev libicu-dev g++ libmcrypt-dev libmagickwand-dev \
    && docker-php-ext-install pdo pdo_mysql zip intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Expose port for Render
EXPOSE 8000

# Start the Laravel application
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=${PORT}"]
