#!/bin/bash
echo "Starting OpenSpecimen Application!"

. defaultvar.sh

echo "Wait for DB server to be ready"
/opt/scripts/waitforit.sh "${DATABASE_HOST}:${DATABASE_PORT}"


/opt/tomcat/latest/bin/catalina.sh start

tail -f $CATALINA_HOME/logs/catalina.out -f /opt/openspecimen/os-data/logs/os.log
