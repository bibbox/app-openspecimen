# OpenSpecimen Tomcat Container
 
FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION="v6.3.x"

# update system
RUN apt-get update -q -y

## INSTALL DEPENDENCIES
# apt install
RUN apt-get install -y -q software-properties-common \
    && apt-get install -y -q apt-utils \
    && apt-get install -y -q wget \
    && apt-get install -y -q gnupg \
    && apt-get install -y -q apt-transport-https \
    && apt-get install -y -q ca-certificates\
    && apt-get install -y -q curl \
    && apt-get install -y -q openjdk-8-jre-headless \
    && apt-get install -y -q openjdk-8-jdk-headless \
    && apt-get install -y -q tomcat9 \
    && apt-get install -y -q nodejs \
    && apt-get install -y -q npm \
    && apt-get install -y -q gradle \
    && apt-get install -y -q git \
    && apt-get install -y -q nano \
    && apt-get install -y -q gawk \
    && apt-get update -y -q \
    && apt-get upgrade -y -q

#npm install
RUN npm install -g bower \
    && npm install -g grunt-cli --sav-dev

##SET UP OPENSPECIMEN BUILD
#ENVIRONMENT
ENV JRE_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    CATALINA_BASE="/var/lib/tomcat9" \
    TOMCAT_HOME="/var/lib/tomcat9" 
ENV export \
    JRE_HOME \
    CATALINA_BASE \
    TOMCAT_HOME

# Directories for Openspecimen log-files/plugins
RUN mkdir "/var/lib/openspecimen" \
    && mkdir "/var/lib/openspecimen/data" \
    && mkdir "/var/lib/openspecimen/plugins" \
    && mkdir "/etc/systemd/system/tomcat9.service.d" \
    && mkdir "/tmp/openspecimen" \
    && mkdir "/usr/share/tomcat9/lib/mysql-connector-java-8.0.18.jar"

#MYSQL-Connector
RUN cd /tmp \
    && wget "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar" 
ADD /tmp/mysql-connector-java-8.0.18/mysql-connector-java-8.0.18.jar /usr/share/tomcat9/lib/mysql-connector-java-8.0.19.jar

#git openspecimen
RUN cd /tmp/openspecimen \
    && git clone https://github.com/krishagni/openspecimen.git -b $VERSION .

#properties & config-files
RUN rm /tmp/openspecimen/build.properties \
    && rm /var/lib/tomcat9/conf/context.xml \
    && rm /var/lib/tomcat9/conf/tomcat-users.xml \
    && rm /tmp/openspecimen/www/package.json
ADD configs/build.properties /tmp/openspecimen/
ADD configs/context.xml /var/lib/tomcat9/conf/
ADD configs/openspecimen.properties /var/lib/tomcat9/conf/
ADD configs/tomcat-users.xml /var/lib/tomcat9/conf/
ADD config/package.json /tmp/openspecimen/www/
RUN sed -i -r 's/^(JAVA_OPTS=.*)"/\1 -Xmx2048m"/' "/etc/default/tomcat9"


#rights and ownerships for installation
RUN chown -R tomcat:tomcat "/var/lib/openspecimen" \
    && chown -R tomcat:tomcat "/var/lib/tomcat9/conf/openspecimen.properties"

##BUILD OPENSPECIMEN

# npm bower install
RUN cd /tpm/openspecimen/www/ \
    && npm install --loglevel=error \
    && bower install --allow-root

#gradle build
RUN cd /tmp/openspecimen \
    && sed -i -e 's/mavenCentral()/maven { url "https://repo.maven.apache.org/maven2" }/g' build.gradle \
    && gradle deploy

#CSet up OS
RUN printf "[Service]\n%s\n" "ReadWritePaths=/var/lib/openspecimen/" > "/etc/systemd/system/tomcat9.service.d/openspecimen.conf" 
#    && mv /var/lib/tomcat9/webapps/openspecimen.war /var/lib/tomcat9/webapps/ROOT.iwas \
#    && rm -rf /var/lib/tomcat9/webapps/ROOT \
#    && rm -rf /var/lib/tomcat9/webbapps/openspecimen \
#    && cp /var/lib/tomcat9/webapps/ROOT.iwas /var/lib/tomcat9/webapps/ROOT.war 


RUN echo 'export PS1="[\u@openspecimen:\w]# "' >> /root/.bashrc

ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
