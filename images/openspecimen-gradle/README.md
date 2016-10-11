![alt text](http://bibbox.org/image/layout_set_logo?img_id=99523&t=1466419185262 "Logo BiBBoX")
# OpenSpecimen Build Container

Linux environment to build `OpenSpecimen` from the source code.
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