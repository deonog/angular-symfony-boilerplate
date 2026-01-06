# Use official PHP 8.4 with FPM as base
FROM php:8.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    nginx \
    supervisor \
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# Install Xdebug for development
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Configure Xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy configuration files
COPY ./docker-nginx/php.ini /usr/local/etc/php/conf.d/custom.ini
COPY ./docker-nginx/nginx.conf /etc/nginx/sites-available/default
COPY ./docker-nginx/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure PHP-FPM to listen on all interfaces (for nginx)
RUN sed -i 's/listen = 9000/listen = 127.0.0.1:9000/' /usr/local/etc/php-fpm.d/zz-docker.conf

# Create user for development
RUN useradd -m -s /bin/bash user \
    && usermod -aG sudo user \
    && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy API files only
COPY --chown=www-data:www-data ./application/api /var/www/html/api/

# Set environment for development
ENV APP_ENV=dev

# Copy .env.example to .env if it doesn't exist
RUN cd /var/www/html/api && cp -n .env.example .env 2>/dev/null || true

# Install Composer dependencies
RUN cd /var/www/html/api && composer update --no-interaction --optimize-autoloader

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/api/var 2>/dev/null || true \
    && chmod -R 775 /var/www/html/api/var 2>/dev/null || true

# Configure SSH
RUN mkdir -p /var/run/sshd \
    && echo 'user:password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create necessary directories
RUN mkdir -p /var/run/php

# Expose ports
EXPOSE 80 22

# Set working directory
WORKDIR /var/www/html/

# Start services with supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

