# image_build/wordpress/Dockerfile

# Start from the official WordPress image as our foundation
FROM wordpress:latest

# Add some useful tools for development.
# mariadb-client allows connecting to the db from this container.
# less is a useful pager.
RUN apt-get update && apt-get install -y mariadb-client less && rm -rf /var/lib/apt/lists/*

# Download the wp-cli phar, make it executable, and move it into the PATH.
# This is the standard installation method for wp-cli.
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
