FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive

# Updating and Upgrading ubuntu
RUN apt-get -y update \
    && apt-get -y upgrade

# Installing Basic Packages in Ubuntu
RUN apt-get -y install software-properties-common openssh-server apt-transport-https git gnupg sudo nano wget curl zip unzip tcl inetutils-ping net-tools

# Set Private key to clone repo
RUN mkdir ~/.ssh
COPY ./ssh-key/ /
RUN mv /id_rsa ~/.ssh && mv /known_hosts ~/.ssh

# Copy bash script inside container
RUN mkdir -p /var/www/bash-scripts
COPY ./bash-scripts/docker-entrypoint.sh /var/www/bash-scripts

# Cloning repo
RUN git config --global user.name Arslan501
RUN git config --global user.email syed.arslan@purelogics.net
RUN git clone git@github.com:Arslan501/laravel-sample-app.git
RUN mv laravel-sample-app /var/www/

# Set working directory
WORKDIR /var/www/laravel-sample-app

# Adding Php repository  for php fpm
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get update

# Install extensions for php
RUN apt-get install -y php8.2 php8.2-fpm php8.2-bcmath php8.2-curl php8.2-imagick php8.2-intl php-json php8.2-mbstring php8.2-mysql php8.2-xml php8.2-zip

# Installing Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d92e6563bbde02') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
# To run composer globally inside container
RUN sudo mv composer.phar /usr/local/bin/composer

# Clear cache
RUN apt-get clean

# Project configurations
RUN chmod 777 -R public bootstrap storage

# Installing nginix
RUN apt-get -y install nginx-extras
RUN sudo apt-get update

# Nginx Configurations
RUN sudo rm -rf /etc/nginx/sites-available/default
RUN sudo rm -rf cd /etc/nginx/sites-enabled/default
COPY ./nginx/laravel.com /etc/nginx/sites-available/laravel.com
RUN ln -s /etc/nginx/sites-available/laravel.com /etc/nginx/sites-enabled/laravel.com

# To make bash script executeable
RUN chmod +x ../bash-scripts/docker-entrypoint.sh

# Expose port 80
EXPOSE 80

# Entrypoint to start nginx
ENTRYPOINT ["../bash-scripts/docker-entrypoint.sh"]

# Starting with bash
CMD ["/bin/bash"]