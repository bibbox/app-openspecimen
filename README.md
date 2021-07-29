# OPENSPECIMEN BIBBOX application

## Hints
* approx. time with medium fast internet connection: **20 minutes**
* level: advanced
* initial user: ** admin **
* initial passwordd: ** Login@123 **

## Docker Images Used 
 * [mySQL](https://hub.docker.com/_/mysql/), offical mySQL container
 * [busybox](https://hub.docker.com/_/busybox/), offical data container
 
## Install Environment Variables
  *	MYSQL_ROOT_PASSWORD = password, only used within the docker container
  * MYSQL_DATABASE = name of the mysql database, typical *phenotips*. The DB file is stored in the mounted volume
  * MYSQL_USER = name of the mysql user, typical *phenotips*
  * MYSQL_PASSWORD = mysql user password, only used within the docker container

## Mounted Volumes

* the mysql datafolder _/var/mysql_ will be mounted to _/opt/apps/INSTANCE_NAME/var/mysql_ in your BIBBOX kit 

## Installation Instructions 

* start your application in the dashboard

## Local Installation

* run **docker-compose up** in the root folder of the project. After a few minutes OpenSpecimen is reachable via **http://localhost:9000/openspecimen** .
* This can be changed in **docker-compose.yml**.
* the permission of the folder ./data hast to be changed.
