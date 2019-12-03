# OpenSpecimen Tomcat Container
 
FROM debian:jessie
ARG DEBIAN_FRONTEND=noninteractive
ARG VERSION="v6.2.x"

RUN apt-get update \
    && apt-get install -y software-properties-common apt-utils wget gnupg \
    apt-transport-https ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Setup JDK
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
    && apt-get update \
    && apt install -y adoptopenjdk-8-hotspot

# Setup tomcat and dependencies
RUN apt-get install -y build-essential libpng-dev \
    && mkdir /opt/tomcat/ \
    && useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat \
    && wget https://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.27/bin/apache-tomcat-9.0.27.tar.gz -P /tmp/ \
    && tar xf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat \
    && ln -s /opt/tomcat/apache-tomcat-9.0.27 /opt/tomcat/latest \
    && sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh' \
    && chown -R tomcat:tomcat /opt/tomcat/apache-tomcat-9.0.27

ENV GRADLE_HOME="/opt/gradle/gradle-2.0"
ENV PATH="${GRADLE_HOME}/bin:${PATH}"

# Setup build tools
RUN wget http://services.gradle.org/distributions/gradle-2.0-bin.zip -P /tmp \
    && apt-get install -y unzip curl git \
    && unzip -d /opt/gradle /tmp/gradle-*.zip \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && cd /tmp \
    && git clone https://github.com/krishagni/openspecimen.git -b $VERSION \
    && rm /tmp/openspecimen/build.properties \
    && rm /opt/tomcat/latest/conf/context.xml \
    && cd openspecimen/www/ \
    && npm install --loglevel=error \
    && npm install --loglevel=error -g grunt gulp-cli bower \
    && npm audit fix \
    && bower install --allow-root \
    && apt remove -y unzip curl \
    && rm -rf /var/lib/apt/lists/*

# Copy config files
ADD configs/build.properties /tmp/openspecimen/
ADD configs/context.xml /opt/tomcat/latest/conf/
ADD configs/openspecimen.properties /opt/tomcat/latest/conf/

# Build WAR file
RUN cd /tmp/openspecimen \
    && gradle build \
    && cp build/libs/openspecimen.war /opt/tomcat/latest/webapps/ \
    && mkdir -p /opt/tomcat/latest/OpenSpecimen/plugins \
    && chown tomcat:tomcat /opt/tomcat/latest/conf/openspecimen.properties \
    && chown tomcat:tomcat /opt/tomcat/latest/conf/context.xml \
    && wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.18/mysql-connector-java-8.0.18.jar -P /opt/tomcat/latest/lib/ \
    && rm -rf /tmp/openspecimen \
    && apt remove -y git

RUN echo 'export PS1="[\u@openspecimen:\w]# "' >> /root/.bashrc

ENTRYPOINT ["/bin/sh"]