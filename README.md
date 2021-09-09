# OPENSPECIMEN BIBBOX(V4) application

## Hints
* approx. time with medium fast internet connection: **5 minutes**
* initial user: ** admin **
* initial password: ** Login@123 **

## Docker Images Used 
 * [mySQL](https://hub.docker.com/_/mysql/), offical mySQL container
 * [openspecimen](https://hub.docker.com/r/bibbox/openspecimen/tags)
 
* this version is compatible with your local BiBBOX(V4)-kit and is also installable in the Store on http://silicolabv4.bibbox.org/
* the local installation uses the **docker-compose.yml**, for the global installation the **docker-compose.yml.template** is considered.

## Local Installation
The following steps must be executed:
* 1) set the permission for the data folder (inside the root folder of the project) like: sudo chmod -R 777 data 
* 2) run **docker-compose up** in the root folder of the project. After a few minutes OpenSpecimen is reachable via **http://localhost:9000/openspecimen**.
* The port and default Environment variables for the used containers are set within the **docker-compose.yml** and can be adapted if desired.

------------------------------------------------------------------------------------------
## In case the installation process reccurently shows the following information message
[main] INFO  liquibase.executor.jvm.JdbcExecutor- SELECT `LOCKED` FROM openspecimen.DATABASECHANGELOGLOCK WHERE ID=1
[main] INFO  liquibase.lockservice.StandardLockService- Waiting for changelog lock....

and the installationis not proceeding, do the following:
* Enter your mysql:8.0.26 container (Attach Shell to it) and execute the commands listed below:
------------------------------------------------------------------------------------------
mysql -uroot -p'openspecimen'

USE openspecimen

SELECT * from DATABASECHANGELOGLOCK;

UPDATE DATABASECHANGELOGLOCK SET LOCKED=FALSE, LOCKGRANTED=null, LOCKEDBY=null where ID=1;

exit
------------------------------------------------------------------------------------------
* and rerun **docker-compose up** in the root folder of the project.  

