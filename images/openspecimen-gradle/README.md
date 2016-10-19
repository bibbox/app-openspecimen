![alt text](http://bibbox.org/image/layout_set_logo?img_id=99523&t=1466419185262 "Logo BIBBOX")
# OpenSpecimen Build Container

Linux environment to build `OpenSpecimen` from the source code. This is part of a `docker-compose file` for runing OpenSpecimen. You can find more infomation about the system ([here](https://github.com/bibbox/app-openspecimen))
Contains all the prerequisites installed to be able to build the `OpenSpecimen` from [source code] (https://github.com/krishagni/openspecimen).
More information on how to build from source code is available [here] (https://openspecimen.atlassian.net/wiki/pages/viewpage.action?pageId=1115955).
The `openspecimen.war` file built will be placed in `/opt/dist/`. 

When you check out the source code from github, you will find a `build.properties` file under the root directory `openspecimen/`. You might want to change 
the configurations of the file. The war file bundled with this image was built using the following `build.properties` configurations:

    app_home = /opt/tomcat
    app_data_dir = /opt/openspecimen/os-data
    app_log_conf =
	datasource_jndi = java:/comp/env/jdbc/openspecimen
	deployment_type = fresh
	database_type = mysql
	database_host = openspecimen-db-${INSTANCE}
	database_port = 3306
	database_name = ${MYSQL_DATABASE}
	database_username = ${MYSQL_USER}
	database_password = ${MYSQL_PASSWORD}
	show_sql = false
	plugin_dir = /opt/openspecimen/os-plugins

The whole image is available at [docker hub] (https://hub.docker.com/r/bibbox/openspecimen-gradle/).

## Environment Variables

When you start the `OpenSpecimen Gradle` image, you can adjust the configuration of the OpenSpecimen builded war file by passing one or more environment variables on the `docker run` command or the `docker-compose file`. You can find a `docker-compose file` with configuration for starting an OpenSpecimen instance on the ([bibbox github](https://github.com/bibbox/app-openspecimen)).

### `RELEASEURL`
The url to the ziped file of the source code. A list of all releases is available ([here](https://github.com/krishagni/openspecimen/releases)).
default "https://github.com/krishagni/openspecimen/archive/v3.3.zip"
### `APP_HOME`
default "/opt/tomcat"
### `APP_DATA_DIR`
default "/opt/openspecimen/os-data"
### `APP_LOG_CONF`
default ""
### `DATASOURCE_JNDI`
default "java:/comp/env/jdbc/openspecimen"
### `DEVELOPMENT_TYPE`
default "fresh"
### `DATABASE_TYPE`
default "mysql"
### `DATABASE_HOST`
default "openspecimen-db-"
### `INSTANCE`
The instance and `DATABASE_HOST` form the host url for the database connection. This is part of hor the instalation process is handeld for the bibbox system.
default ""
### `DATABASE_PORT`
default "database_port = 3306"
### `MYSQL_DATABASE`
default "openspecimen"
### `MYSQL_USER`
default "openspecimen"
### `MYSQL_PASSWORD`
default "openspecimen"
### `SHOW_SQL`
default "false"
### `PLUGIN_DIR`
default "/opt/openspecimen/os-plugins"
