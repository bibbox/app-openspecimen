#!/bin/bash
echo "Starting OpenSpecimen Application!"

. defaultvar.sh

echo "Wait for DB server to be ready"
/opt/scripts/waitforit.sh "${DATABASE_HOST}:${DATABASE_PORT}"

file=/opt/dist/deployed.done
if [ ! -f $file ] ; then
    
  while [ ! -f /opt/dist/openspecimen.war ]
  do
    echo "Waiting for openspecimen.war file."
    sleep 5
  done
  
cat << EOF > $file
OpenSpecimen Application deployed
EOF

  cp /opt/dist/openspecimen.war $CATALINA_HOME/webapps/ROOT.war
  sed -i "s#§§username#${MYSQL_USER}#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§password#${MYSQL_PASSWORD}#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§host#${DATABASE_HOST}#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§database#${MYSQL_DATABASE}#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§useddatabasetype#${USED_DATABASE_TYPE}#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§port#${DATABASE_PORT}#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§useddatabasedriver#${DATABASE_DRIVER}#g" /opt/tomcat/conf/context.xml
  
  sed -i "s#§§name#${TOMCAT_MANAGER_USER}#g" /opt/tomcat/conf/tomcat-users.xml
  sed -i "s#§§password#${TOMCAT_MANAGER_PASSWORD}#g" /opt/tomcat/conf/tomcat-users.xml
  
  sed -i "s#§§databasedriver#${DATABASE_DRIVER}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§username#${MYSQL_USER}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§password#${MYSQL_PASSWORD}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§host#${DATABASE_HOST}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§database#${MYSQL_DATABASE}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§port#${DATABASE_PORT}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§useddatabasetype#${USED_DATABASE_TYPE}#g" /opt/scripts/sqlproperties.properties
  
  sed -i "s#§§institutename#${INSTITUTE_NAME}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§emailaddress#${EMAIL_ADDRESS}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§firstname#${FIRST_NAME}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§lastname#${LAST_NAME}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§loginname#${LOGIN_NAME}#g" /opt/scripts/sqlproperties.properties
  sed -i "s#§§address#${ADDRESS}#g" /opt/scripts/sqlproperties.properties
  
  mkdir /opt/scripts/adduser_lib
  ln -s /opt/tomcat/lib/mysql-connector-java-5.1.31.jar /opt/scripts/adduser_lib/mysql-connector-java-5.1.31.jar
  
  $CATALINA_HOME/bin/startup.sh
  
  java -jar /opt/scripts/adduser.jar &
  
else
  cp /opt/dist/openspecimen.war $CATALINA_HOME/webapps/ROOT.war
  $CATALINA_HOME/bin/startup.sh
fi

tail -f $CATALINA_HOME/logs/catalina.out -f /opt/openspecimen/os-data/logs/os.log