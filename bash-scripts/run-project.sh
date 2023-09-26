#!/bin/bash

containerID=$(sudo docker ps | grep -w laravel-sample-app | awk '{print $1}')
sudo docker exec $containerID composer update
sudo docker exec $containerID php artisan migrate