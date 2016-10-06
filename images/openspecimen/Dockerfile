# debian jessie + oracle java
 # 
 # VERSION 0.0.1 
 #
 
 # 0.0.1 : initial creation of image with java version 1.8.0_72-b15 (766.4 MB)
 
 FROM debian:jessie
 
 MAINTAINER Suyesh Amatya <suyesh.amatya@ki.se>
 
 # Install JDK 8
 RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
       && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
       && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
       && apt-get update \
       && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
       && apt-get install -y oracle-java8-installer unzip \
       && apt-get install -y oracle-java8-set-default
 
 
 # Define commonly used JAVA_HOME variable      
 ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
 ENV PATH $PATH:$JAVA_HOME/bin
 
 # Install tomcat
 
 ENV TOMCAT_MAJOR 7
 ENV TOMCAT_VERSION 7.0.70
 
 
 
 RUN wget --quiet --no-cookies https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
 tar xzvf /tmp/tomcat.tgz -C /opt && \
 mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
 rm /tmp/tomcat.tgz && \
 rm -rf /opt/tomcat/webapps/docs && \
 rm -rf /opt/tomcat/webapps/examples
 
 
 #Make appropriate directories for OpenSpecimen
 RUN mkdir -p /opt/openspecimen/os-data
 RUN mkdir -p /opt/openspecimen/os-plugins
 
 # Add admin/admin user
 ADD tomcat-users.xml /opt/tomcat/conf/
 
 # Add data source configuration for MySQL root user (username="root" password="openspecimen")
 ADD context.xml /opt/tomcat/conf/
 
 
 # Add MySQL connector jar
 RUN wget  http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.31/mysql-connector-java-5.1.31.jar -O /opt/tomcat/lib/mysql-connector-java-5.1.31.jar
 
 # Deploy openspecimen war
 ADD openspecimen.war /opt/tomcat/webapps/
 
 
 ENV CATALINA_HOME /opt/tomcat
 ENV PATH $PATH:$CATALINA_HOME/bin
 
-
-EXPOSE 8080
-
 VOLUME "/opt/tomcat/webapps"
 WORKDIR /opt/tomcat
 
 
 # Install Gradle
 
 #ENV GRADLE_VERSION 2.13
 
 #RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip -O /tmp/gradle.zip \
 #&& unzip /tmp/gradle.zip \
 #&& mv /tmp/gradle-${GRADLE_VERSION} /opt \
 #&& rm /tmp/gradle.zip
 
 # Set Appropriate Environmental Variables
 #ENV GRADLE_HOME /opt/gradle
 #ENV PATH $PATH:$GRADLE_HOME/bin
 
 
 # Launch Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]