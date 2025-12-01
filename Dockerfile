FROM php:8.4-fpm

# system packages + php extensions needed for Laravel
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libicu-dev \
    libpq-dev \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install pdo_mysql zip mbstring exif pcntl bcmath xml gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# install composer
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

# set working dir
WORKDIR /var/www/html

# copy composer files first to leverage Docker cache (optional)
COPY composer.json composer.lock ./

# leave vendor installation to run manually or run here (choose one)
# RUN composer install --no-dev --prefer-dist --no-scripts --no-interaction --optimize-autoloader

# copy the rest of the app
# COPY . .

# change permissions (will also run inside container if mounted)
RUN chown -R www-data:www-data /var/www/html || true

EXPOSE 9000

CMD ["php-fpm"]
