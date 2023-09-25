#!/bin/bash

sudo service nginx start
sudo service php8.2-fpm start

exec "$@";
