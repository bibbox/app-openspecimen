![alt text](http://bibbox.org/image/layout_set_logo?img_id=99523&t=1466419185262 "Logo BiBBoX")
# Docker Tools for OpenSpecimen


The Dockerfile installs `JDK 8` and `Tomcat 7.0.70`.
Copies `tomcat-users.xml` and `context.xml` to `/opt/tomcat/conf/`.

Specifies MySQL root user (`username="root"`, `password="openspecimen"`).

Copies `openspecimen.war` to `/opt/tomcat/webapps/`.

Also copies `mysql-connector-java-5.1.31.jar` to `/opt/tomcat/lib/`. 

For the database you can use  [MySQL image] (https://hub.docker.com/r/mysql/mysql-server/). You need to download this image and then run it 
to start the MySQL server instance.

Docker Run Command: `docker run --name my-container-name -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql/mysql-server:tag`

You need to create a database named `openspecimen`.

If you want to use different database name and different MySQL root username and password, you have to change the `context.xml` file. Also you need to build your
own openspecimen.war file with the configurations you choose. See more about this [here] 
(https://github.com/BiBBox/docker-tools/tree/master/openspecimen/images/gradle).

Once you have the database container running and the database created, you can run this image and connect it to the database container.

Docker Run Command: `docker run --name app-container-name --link my-container-name:mysql -p 8080:8080 -d app-that-uses-mysql`



