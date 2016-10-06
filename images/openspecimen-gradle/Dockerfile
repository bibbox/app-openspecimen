# Gradle build container for Openspecimen
# 
# VERSION 0.0.1 
# 
# 0.0.1 : initial creation of image with Liferay and Data from RD-Connect

FROM debian:jessie 

MAINTAINER Robert Reihs <robert.reihs@gmail.com>

RUN apt-get update \
    && apt-get -y install curl unzip git \
    && echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install oracle-java8-installer \
    && apt-get -y install oracle-java8-set-default \
    && mkdir -p /opt/packages/gradle \
    && cd /opt/packages/gradle \
    && wget https://services.gradle.org/distributions/gradle-3.0-bin.zip \
    && unzip gradle-3.0-bin.zip \
    && rm gradle-3.0-bin.zip \
    && ln -s /opt/packages/gradle/gradle-3.0 /opt/gradle \
    && echo '# Gradle' >> /.profile \
    && echo 'if [ -d "/opt/gradle" ]; then' >> /.profile \
    && echo '  export GRADLE_HOME="/opt/gradle"' >> /.profile \
    && echo '  PATH="$PATH:$GRADLE_HOME/bin"' >> /.profile \
    && echo 'fi' >> /.profile \
    && . /.profile \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get -y install nodejs \
    && npm install -g bower \
    && npm install -g yo \
    && npm install -g grunt-cli \
    && npm install -g grunt \
    && mkdir -p /opt/dist
    
    
ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
    