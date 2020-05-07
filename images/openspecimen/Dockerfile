# OpenSpecimen Tomcat Container
 
FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION="v6.3.x"

# update system
RUN apt-get update -y -q \
    && apt-get upgrade -y -q \
    && apt-get install -y -q apt-utils

## INSTALL DEPENDENCIES
# apt install
RUN apt-get install -y -q software-properties-common \
    && apt-get install -y -q wget \
    && apt-get install -y -q gnupg \
    && apt-get install -y -q apt-transport-https \
    && apt-get install -y -q ca-certificates\
    && apt-get install -y -q curl \
    && apt-get install -y -q dirmngr \
    && apt-get install -y -q openjdk-8-jre-headless \
    && apt-get install -y -q openjdk-8-jdk-headless \
    && apt-get update -y -q
RUN apt-get install -y -q tomcat9 \
    && apt-get install -y -q gcc g++ make \
    && apt-get update -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt install -y -q nodejs \
    && node -v \
    && apt-get install -y -q gradle \
    && apt-get install -y -q git \
    && apt-get install -y -q nano \
    && apt-get install -y -q gawk \
    && apt-get update

#npm install
RUN npm install bower -g \
    && npm install grunt-cli -g --save-dev \
    && npm install gulp-cli -g 

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
    && mkdir "/tmp/openspecimen" \
    && mkdir "/var/lib/tomcat9/temp"

#MYSQL-Connector
RUN cd /var/lib/tomcat9/lib \
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar

#git openspecimen
RUN cd /tmp/openspecimen \
    && git clone https://github.com/krishagni/openspecimen.git .

#properties & config-files
RUN rm /tmp/openspecimen/build.properties \
    && rm /var/lib/tomcat9/conf/context.xml \
    && rm /var/lib/tomcat9/conf/tomcat-users.xml
ADD configs/build.properties /tmp/openspecimen/
ADD configs/context.xml /var/lib/tomcat9/conf/
ADD configs/openspecimen.properties /var/lib/tomcat9/conf/
ADD configs/tomcat-users.xml /var/lib/tomcat9/conf/
ADD configs/package.json /tmp/openspecimen/www/



#rights and ownerships for installation
RUN chown -R tomcat:tomcat "/var/lib/openspecimen" \
    && chown -R tomcat:tomcat "/var/lib/tomcat9/conf/openspecimen.properties"
#RUN chmod -R 777 "/var/lib/openspecimen" \
#    && chmod -R 777 "/var/lib/tomcat9/conf/openspecimen.properties"

##BUILD OPENSPECIMEN
#JSON PATCH

#RUN echo "$(cat <<EOF \
#    --- package.json        2019-07-17 15:14:00.419021754 +0000 \
#    +++ package.json.new    2019-07-18 04:27:36.961700752 +0000 \
#    @@ -34,7 +34,7 @@ \
#    "grunt-contrib-copy": "^0.7.0", \
#    "grunt-contrib-cssmin": "^0.10.0", \
#    "grunt-contrib-htmlmin": "^0.3.0", \
#    - "grunt-contrib-imagemin": "0.9.1", \
#    + "grunt-contrib-imagemin": "^1.0.0", \
#    "grunt-contrib-uglify": "^0.6.0", \
#    "grunt-contrib-watch": "^0.6.1", \
#    "grunt-filerev": "^2.1.1", \
#    EOF)apt" | patch

# npm bower install
RUN cd /tmp/openspecimen/www \
    && npm install --loglevel=error --force-latest \
    && bower install --allow-root --stacktrace


#gradle build
RUN cd /tmp/openspecimen \
    && sed -i -e 's#mavenCentral()#maven { url "https://repo.maven.apache.org/maven2" }#g' build.gradle \
    && gradle deploy

#CSet up OS
RUN sed -i -r 's/^(JAVA_OPTS=.*)"/\1 -Xmx2048m"/' "/etc/default/tomcat9"
RUN printf "[Service]\n%s\n" "ReadWritePaths=/var/lib/openspecimen/" > "/etc/systemd/system/tomcat9.service.d/openspecimen.conf" 
#    && mv /var/lib/tomcat9/webapps/openspecimen.war /var/lib/tomcat9/webapps/ROOT.war \
#    && rm -rf /var/lib/tomcat9/webapps/ROOT 

RUN echo 'export PS1="[\u@openspecimen:\w]# "' >> /root/.bashrc

ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
