# Use official PHP 8.3 with Apache as base
FROM php:8.3-apache

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
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/*


# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Xdebug for development
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Configure Xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure Apache
ADD ./docker-apache/php.ini /usr/local/etc/php/
COPY ./docker-apache/apache.conf /etc/apache2/sites-available/
RUN a2ensite apache.conf && a2enmod rewrite

# Create user for development
RUN useradd -m -s /bin/bash user \
    && usermod -aG sudo user \
    && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Copy API files only
COPY --chown=user:user ./application/api /var/www/html/api/

# Set environment for development
ENV APP_ENV=dev

# Install Composer dependencies
RUN cd /var/www/html/api && composer update --no-interaction --optimize-autoloader

# Configure SSH
RUN mkdir -p /var/run/sshd \
    && echo 'user:password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Expose ports
EXPOSE 80 8888 22

# Set working directory
WORKDIR /var/www/html/

# Create startup script
RUN echo '#!/bin/bash' > /start.sh \
    && echo '/usr/sbin/sshd -D &' >> /start.sh \
    && echo 'apache2-foreground' >> /start.sh \
    && chmod +x /start.sh

# Start services
CMD ["/start.sh"]
