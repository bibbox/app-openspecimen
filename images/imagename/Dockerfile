# OpenSpecimen Tomcat Container
 
FROM debian:jessie
ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION="v6.3.x"

# update system
RUN apt-get update 

## INSTALL DEPENDENCIES
# apt install
RUN apt install -y -q \
    software-properties-common \
    apt-utils \
    wget \
    gnupg \
    apt-transport-https \
    ca-certificates\
    curl \
    openjdk-8-jre-headless \
    openjdk-8-jdk-headless \
    tomcat9 \
    nodejs \
    npm \
    gradle \
    git \
    nano \
    gawk

RUN rm -rf /var/lib/apt/lists/*

#npm install
RUN npm install -g bower grunt-cli

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
RUN mkdir \
    "/var/lib/openspecimen" \
    "/var/lib/openspecimen/data" \
    "/var/lib/openspecimen/plugins" \
    "/etc/systemd/system/tomcat9.service.d"

#MYSQL-Connector
RUN wget "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar" /tmp \
    cp "/tmp/mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar" "/usr/share/tomcat9/lib"

#git openspecimen
RUN git clone https://github.com/krishagni/openspecimen.git -b $VERSION /tmp

#properties & config-files
RUN rm \
    /tmp/openspecimen/build.properties \
    /var/lib/tomcat9/conf/context.xml \
    /var/lib/tomcat9/conf/tomcat-users.xml
ADD configs/build.properties /tmp/openspecimen/
ADD configs/context.xml /var/lib/tomcat9/conf/
ADD configs/openspecimen.properties /var/lib/tomcat9/conf/
ADD configs/tomcat-users.xml /var/lib/tomcat9/conf/
RUN sed -i -r 's/^(JAVA_OPTS=.*)"/\1 -Xmx2048m"/' "/etc/default/tomcat9"


#rights and ownerships for installation
RUN chown -R $$USER:USER \
    "/var/lib/openspecimen" \
    "/var/lib/tomcat9/conf/openspecimen.properties"

##BUILD OPENSPECIMEN
#JSON PATCH
RUN cd /tmp/openspecimen/www
RUN echo "$(cat <<EOF \
--- package.json        2019-07-17 15:14:00.419021754 +0000 \
+++ package.json.new    2019-07-18 04:27:36.961700752 +0000 \
@@ -34,7 +34,7 @@
    "grunt-contrib-copy": "^0.7.0", \
    "grunt-contrib-cssmin": "^0.10.0", \
    "grunt-contrib-htmlmin": "^0.3.0", \
    - "grunt-contrib-imagemin": "0.9.1", \
    + "grunt-contrib-imagemin": "^1.0.0", \
    "grunt-contrib-uglify": "^0.6.0", \
    "grunt-contrib-watch": "^0.6.1", \
    "grunt-filerev": "^2.1.1", \
    EOF)apt" | patch

# npm bower install
RUN npm install --loglevel=error \
    && bower install --allow-root

#gradle build
RUN cd /tmp/openspecimen
RUN sed -i -e 's/mavenCentral()/maven { url "https://repo.maven.apache.org/maven2" }/g' build.gradle
RUN gradle build --stacktrace --debug \
    gradle --stop \
    gradle deploy

#CSet up OS
RUN printf "[Service]\n%s\n" "ReadWritePaths=/var/lib/openspecimen/" > "/etc/systemd/system/tomcat9.service.d/openspecimen.conf"
RUN rm -rf /opt/tomcat/latest/webapps/ROOT \
    && cp build/libs/openspecimen.war /var/lib/tomcat9/webapps/ROOT.war \


# Build WAR file
RUN cd /tmp/openspecimen \
    && sed -i 's#mavenCentral()#maven { url "https://repo.maven.apache.org/maven2" }#g' /tmp/openspecimen/build.gradle \
    && gradle build  --stacktrace --debug \
    && cp build/libs/openspecimen.war /opt/tomcat/latest/webapps/ROOT.war \
    && rm -r /opt/tomcat/latest/webapps/ROOT \
    && chown tomcat:tomcat /opt/tomcat/latest/conf/openspecimen.properties \
    && chown tomcat:tomcat /opt/tomcat/latest/conf/context.xml \
    && wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar -P /opt/tomcat/latest/lib/ \
    && rm -rf /tmp/openspecimen \
    && rm -rf /opt/tomcat/latest/webapps/ROOT \
    && apt remove -y git

RUN echo 'export PS1="[\u@openspecimen:\w]# "' >> /root/.bashrc

ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
