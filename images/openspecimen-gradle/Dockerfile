# Gradle build container for Openspecimen
# 
# VERSION 0.0.1 
# 
# 0.0.1 : initial creation of image with Liferay and Data from RD-Connect

FROM debian:jessie 

MAINTAINER Robert Reihs <robert.reihs@gmail.com>

RUN apt-get update \
    && apt-get -y install curl unzip git apt-utils software-properties-common \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 \
	&& apt-get -y install python-software-properties \
	&& apt-get update \
    && echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& echo oracle-java13-installer shared/accepted-oracle-license-v1-2 select true | /usr/bin/debconf-set-selections \
    && echo "deb http://ppa.launchpad.net/linuxuprising/java/ubuntu bionic main" | tee etc/apt/sources.list.d/linuxuprising-java.list \
	&& apt-get -y install dirmngr \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 73C3DB2A \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install oracle-java13-installer \
    && apt-get -y install oracle-java13-set-default \
    && mkdir -p /opt/packages/gradle \
    && cd /opt/packages/gradle \
    && wget https://services.gradle.org/distributions/gradle-5.0-bin.zip \
    && unzip gradle-5.0-bin.zip \
    && rm gradle-5.0-bin.zip \
    && ln -s /opt/packages/gradle/gradle-5.0 /opt/gradle \
    && echo '# Gradle' >> /.profile \
    && echo 'if [ -d "/opt/gradle" ]; then' >> /.profile \
    && echo '  export GRADLE_HOME="/opt/gradle"' >> /.profile \
    && echo '  PATH="$PATH:$GRADLE_HOME/bin"' >> /.profile \
    && echo 'fi' >> /.profile \
    && . /.profile \
    && curl -sL https://deb.nodesource.com/setup_13.x | bash - \
    && apt-get -y install nodejs \
    && npm install -g bower \
    && npm install -g yo \
    && npm install -g grunt-cli \
    && npm install -g grunt \
    && mkdir -p /opt/dist \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
    
ADD scripts /opt/scripts
WORKDIR /opt/scripts
RUN chmod a+x *.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
    