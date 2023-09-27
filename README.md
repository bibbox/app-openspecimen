# openspecimen BIBBOX application

This container can be installed as [BIBBOX APP](https://bibbox.readthedocs.io/en/latest/ "BIBBOX App Store") or standalone. 

- after the docker installation follow these [instructions](INSTALL-APP.md)

## Standalone Installation 

Clone the github repository. If necessary change the ports in the environment file `.env` and the volume mounts in `docker-compose.yml`.

```
git clone https://github.com/bibbox/app-openspecimen
cd app-openspecimen
docker-compose up -d
```

The main app can be opened and set up at
```
http://localhost:9000
```

## Install within BIBBOX

Visit the BIBBOX page and find the App by its name in the Store. Click on the symbol and select Install. Then fill the parameters below and name your app click install again.

## Docker Images used
  - [mysql](https://hub.docker.com/r/mysql) 
  - [bibbox/openspecimen](https://hub.docker.com/r/bibbox/openspecimen) 


 
## Install Environment Variables
  - MYSQL_DATABASE_USER = The User of the DB created for OpenSpecimen
  - MYSQL_DATABASE_PASSWORD = The Password of the DB User created for OpenSpecimen

  
The default values for the standalone installation are:
  - MYSQL_DATABASE_USER = openspecimen
  - MYSQL_DATABASE_PASSWORD = openspecimen

  
## Mounted Volumes
### mysql Conatiner
  - *./data/mysql:/var/lib/mysql*
  - *./configs/openspecimen.cnf:/etc/mysql/conf.d/openspecimen.cnf:ro*
### bibbox/openspecimen Conatiner
  - *./data/os-data:/var/lib/tomcat9/openspecimen/data*
  - *./data/os-plugins:/var/lib/tomcat9/openspecimen/plugins*
  - *./configs/openspecimen/ROOT:/var/lib/tomcat9/webapps/ROOT*
  - *./configs/openspecimen/scripts/entrypoint.sh:/opt/scripts/entrypoint.sh*
