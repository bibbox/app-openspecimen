# openspecimen BIBBOX application

This container can be installed as [BIBBOX APP](https://bibbox.readthedocs.io/en/latest/ "BIBBOX App Store") or standalone. 

After the docker installation follow these [instructions](INSTALL-APP.md).

## Standalone Installation 

Clone the github repository. If necessary change the ports in the environment file `.env` and the volume mounts in `docker-compose.yml`.

```
git clone https://github.com/bibbox/app-openspecimen
cd app-openspecimen
docker network create bibbox-default-network
docker-compose up -d
```

The main App can be opened and set up at:
```
http://localhost:9000
```

## Install within BIBBOX

Visit the BIBBOX page and find the App by its name in the store. Click on the symbol and select install. Then fill the parameters below and name your App, click install again.

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
### mysql Container
  - *./data/mysql:/var/lib/mysql*
  - *./configs/openspecimen.cnf:/etc/mysql/conf.d/openspecimen.cnf:ro*
### bibbox/openspecimen Container
  - *./data/os-data:/var/lib/tomcat9/openspecimen/data*
  - *./data/os-plugins:/var/lib/tomcat9/openspecimen/plugins*
  - *./configs/openspecimen/ROOT:/var/lib/tomcat9/webapps/ROOT*
  - *./configs/openspecimen/scripts/entrypoint.sh:/opt/scripts/entrypoint.sh*

## In case the installation process reccurently shows the following information message

INFO  liquibase.executor.jvm.JdbcExecutor- SELECT `LOCKED` FROM openspecimen.DATABASECHANGELOGLOCK WHERE ID=1
INFO  liquibase.lockservice.StandardLockService- Waiting for changelog lock....

and the installationis not proceeding, do the following:
* Enter your mysql:8.0.26 container (Attach Shell to it) and execute the commands listed below:
------------------------------------------------------------------------------------------
mysql -uroot -p'openspecimen' (or your set MYSQL_ROOT_PASSWORD)

USE openspecimen

SELECT * from DATABASECHANGELOGLOCK;

UPDATE DATABASECHANGELOGLOCK SET LOCKED=FALSE, LOCKGRANTED=null, LOCKEDBY=null where ID=1;

------------------------------------------------------------------------------------------
* and rerun **docker-compose up** in the root folder of the project.  

------------------------------------------------------------------------------------------



