# OpenSpecimen Tomcat Container
# 
# VERSION 0.0.2 
#
 
# 0.0.1 : initial creation of image with java version 1.8.0_72-b15 (766.4 MB)
# 0.0.2 : use existing build for tomcat and autobuild gradle container

FROM tomcat:9.0-jre8

MAINTAINER Suyesh Amatya <suyesh.amatya@ki.se>

RUN apt-get update \
    && rm -r $CATALINA_HOME/webapps/ROOT \
    && rm -r $CATALINA_HOME/webapps/docs \
    && rm -r $CATALINA_HOME/webapps/examples \
    && mkdir -p /opt/openspecimen/os-data \
    && mkdir -p /opt/openspecimen/os-plugins \
    && ln -s "$CATALINA_HOME" /opt/tomcat \
    && wget http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.31/mysql-connector-java-5.1.31.jar -O /opt/tomcat/lib/mysql-connector-java-5.1.31.jar
    
# Add admin/admin user
ADD configs/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml
# Add data source configuration for MySQL root user (username="root" password="openspecimen")
ADD configs/context.xml /opt/tomcat/conf/context.xml
ADD configs/openspecimen.properties /opt/tomcat/conf/openspecimen.properties
# ADD openspecimen war file build with the gradle container with default values
ADD openspecimen.war /opt/dist/openspecimen.war

ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
