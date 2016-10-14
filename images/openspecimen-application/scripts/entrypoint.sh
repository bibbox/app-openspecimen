#!/bin/bash
echo "Starting OpenSpecimen Application!"

file=/opt/dist/deployed.done
if [ ! -f $file ] ; then
  
  cat << EOF > $file
OpenSpecimen Application deployed
EOF

  cp /opt/dist/openspecimen.war $CATALINA_HOME/webapps/ROOT.war
  sed -i "s#§§username#$MYSQL_USER#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§password#$MYSQL_PASSWORD#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§host#openspecimen-db-$INSTANCE#g" /opt/tomcat/conf/context.xml
  sed -i "s#§§database#$MYSQL_DATABASE#g" /opt/tomcat/conf/context.xml
  
  
fi

tail -f /dev/null

#$CATALINA_HOME/bin/startup.sh
#tail -f $CATALINA_HOME/logs/catalina.out -f /opt/openspecimen/os-data/logs/os.log