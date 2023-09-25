# *User Manual*
## *1. To Run Project follow these steps*
- Set repo of project inside image file without .env file
- Create env file inside envoirnment_files directory
- Now to run project execute following command ***( docker-compose up -d )*** 
- After that run **sh bash-scripts/run-project.sh** bash-scripts directory.

## *2. To get IP of container run following commands*
- To check containerID run ***( docker ps )***
- To check ip of container
    ***( docker inspect --format='{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containerID )***
- For existing project after getting ip copy it inside ***( /wordpress/wp-config.php )*** in database host option

## *3. To use phpmyadmin go on* ***( localhost:81 )***
- Use ip address of mysql container in server option
- In username use *root* as user name
- Get password from *docker-compose.yml

## *4. To Destroy Containers follow these steps*
- After complete your work before termination of containers take dump of db by running following command ***( docker exec -it $containerID mysqldump -u root -pwordpress@123 -d wordpress > wordpress.sql )***
- Now to destroy containers run ***( docker-compose down )***


## *Note: This Project is not for production to make it production ready you need to work on secrets, nginx, and dockerfile etc. Consider it as boiler plate*