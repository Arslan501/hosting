#!/bin/bash

containerID=$(sudo docker ps | grep -w mysql | awk '{print $1}')
containerIP=$(sudo docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containerID)
sed '/DB_HOST=/s/$/'${containerIP}'/' ../envoirnment_files/.env > ../laravel-sample-app/.env
