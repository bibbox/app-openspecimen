![alt text](http://bibbox.org/image/layout_set_logo?img_id=99523&t=1466419185262 "Logo BIBBOX")
# OpenSpecimen Application Container

A tomcat based container that runs the OpenSpeciment Application image. The image contains a build war file that was setup with the default values of the ([OpenSpecimen build image](https://hub.docker.com/r/bibbox/openspecimen-gradle/)). This container is part of a ([compose file for the BIBBOX project](https://github.com/bibbox/app-openspecimen)), but can also run seperatly. If you use this container with your mysql databse you have to set `lower_case_table_names=1` in the config.

## Environment Variables
When you start the `OpenSpecimen Application` image, you can adjust the configuration of the OpenSpecimen application container by passing one or more environment variables on the `docker run` command or the `docker-compose file`. You can find a `docker-compose file` with configuration for starting an OpenSpecimen instance on the ([bibbox github](https://github.com/bibbox/app-openspecimen)).

The default password for the user created is Login!@3 

### `MYSQL_USER`
default "openspecimen"
### `MYSQL_PASSWORD`
default "openspecimen"
### `MYSQL_DATABASE`
default "openspecimen"
### `DATABASE_TYPE`
default "mysql"
### `DATABASE_DRIVER`
default "com.mysql.jdbc.Driver"
### `DATABASE_HOST`
default "openspecimen-db"
### `DATABASE_PORT`
default "database_port = 3306"
### `TOMCAT_MANAGER_USER`
default "admin"
### `TOMCAT_MANAGER_PASSWORD`
default "admin"
### `INSTITUTE_NAME`
default "BIBBOX Demo Biobank"
### `EMAIL_ADDRESS`
default "admin@bibbox.org"
### `FIRST_NAME`
default "Admin"
### `LAST_NAME`
default "Bibbox"
### `LOGIN_NAME`
default "bibboxadmin"
### `ADDRESS`
default ""