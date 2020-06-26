# OpenSpecimen Tomcat Container
 
FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION="v7.0.x"

# update system
RUN apt-get update -y -q \
    && apt-get upgrade -y -q \
    && apt-get install -y -q apt-utils

## INSTALL DEPENDENCIES
# apt install
RUN apt-get install -y -q openjdk-8-jre-headless \
    && apt-get install -y -q openjdk-8-jdk-headless \
    && apt-get install -y -q tomcat9 \
    && apt-get install -y -q nano \
    && apt-get install -y -q wget \
    && apt-get update -y -q

##SET UP OPENSPECIMEN BUILD
#ENVIRONMENT
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/" 
ENV CATALINA_BASE="/var/lib/tomcat9" 
ENV TOMCAT_HOME="/var/lib/tomcat9" 
ENV export JAVA_HOME 
ENV export CATALINA_BASE 
ENV export TOMCAT_HOME

# Directories for Openspecimen log-files/plugins
RUN mkdir "/var/lib/openspecimen" \
    && mkdir "/var/lib/openspecimen/data" \
    && mkdir "/var/lib/openspecimen/plugins" \
    && mkdir "/etc/systemd/system/tomcat9.service.d" \
    && mkdir "/var/lib/tomcat9/temp"

#MYSQL-Connector
RUN cd /usr/share/tomcat9/lib \
    && wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar


#properties & config-files
RUN rm /var/lib/tomcat9/conf/context.xml \
    && rm /var/lib/tomcat9/conf/tomcat-users.xml
ADD configs/context.xml /var/lib/tomcat9/conf/
ADD configs/openspecimen.properties /var/lib/tomcat9/conf/
ADD configs/tomcat-users.xml /var/lib/tomcat9/conf/


#rights and ownerships for installation
RUN chown -R tomcat:tomcat "/var/lib/openspecimen" \
    && chown -R tomcat:tomcat "/var/lib/tomcat9/conf/openspecimen.properties"

#CSet up OS
RUN sed -i -r 's/^(JAVA_OPTS=.*)"/\1 -Xmx2048m"/' "/etc/default/tomcat9"
RUN printf "[Service]\n%s\n" "ReadWritePaths=/var/lib/openspecimen/" > "/etc/systemd/system/tomcat9.service.d/openspecimen.conf"
#    && rm -rf /var/lib/tomcat9/webapps/ROOT \
#    && mv /var/lib/tomcat9/webapps/openspecimen.war /var/lib/tomcat9/webapps/ROOT.war
#     

RUN echo 'export PS1="[\u@openspecimen:\w]# "' >> /root/.bashrc


ADD configs/openspecimen.war /var/lib/tomcat9/webapps/openspecimen.war



ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
