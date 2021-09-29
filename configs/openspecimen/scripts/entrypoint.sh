#!/bin/bash
echo "Starting OpenSpecimen Application!"

. defaultvar.sh

echo "Wait for DB server to be ready"
/opt/scripts/waitforit.sh "${DATABASE_HOST}:${DATABASE_PORT}"


/usr/share/tomcat9/bin/catalina.sh start

tail -f /var/lib/tomcat9/logs/catalina.out -f /var/lib/openspecimen/data/logs/os.log
