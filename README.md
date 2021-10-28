# OPENSPECIMEN BIBBOX(V4) application

This container can be installed as [BIBBOX(V4) APP]http://bibbox.readthedocs.io/en/latest/admin-documentation/ "BIBBOX App Store") or standalone. 
* the standalone installation uses the **docker-compose.yml**, for the installation as a BIBBOX(V4) APP the **docker-compose.yml.template** is considered.


## Hints

* approx. time with medium fast internet connection: **5 minutes**
* initial user: ** admin **
* initial password: ** Login@123 **


## Docker Images Used 

 * [mySQL](https://hub.docker.com/_/mysql/), offical mySQL container
 * [openspecimen](https://hub.docker.com/r/bibbox/openspecimen/tags)
 

## Standalone Installation 

The following steps must be executed:
* 1) set the permission for the data folder (inside the root folder of the project) like: sudo chmod -R 777 data 
* 2) run **docker-compose up** in the root folder of the project. After a few minutes OpenSpecimen is reachable via **http://localhost:9000/openspecimen**.
* The port and default Environment variables for the used containers are set within the **docker-compose.yml** and can be adapted if desired.


## Install Environment Variables

  * MYSQL_ROOT_PASSWORD = password, only used within the docker container
  * MYSQL_DATABASE = name of the mysql database, typical *openspecimen*. The DB file is stored in the mounted volume
  * MYSQL_USER = name of the mysql user, typical *openspecimen*
  * MYSQL_PASSWORD = mysql user password used in the setup of seeddms, for testing you can stay with `seeddms4bibbox`
  * INSTITUTE_NAME = freely selectable by the user
  * EMAIL_ADRESS = freely selectable by the user
  * FIRST_NAME = freely selectable by the user
  * LAST_NAME = freely selectable by the user
  * LOGIN_NAME = freely selectable by the user
  * PORT = 9000


------------------------------------------------------------------------------------------
## In case the installation process reccurently shows the following information message

INFO  liquibase.executor.jvm.JdbcExecutor- SELECT `LOCKED` FROM openspecimen.DATABASECHANGELOGLOCK WHERE ID=1
INFO  liquibase.lockservice.StandardLockService- Waiting for changelog lock....

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

