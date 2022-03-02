#!/bin/bash

python3 -m pip install /var/lib/openspecimen/plugins/OpenSpecimenAPIconnector-0.9.2-py3-none-any.whl
echo "Starting OpenSpecimen Application!"

. defaultvar.sh

sed -e "s/__DB_PW/$MYSQL_PASSWORD/g" -e "s/__DB_USER/$MYSQL_USER/g" /var/lib/tomcat9/conf/context.xml.template > /var/lib/tomcat9/conf/context.xml

echo "Wait for DB server to be ready"
/opt/scripts/waitforit.sh "${DATABASE_HOST}:${DATABASE_PORT}"


/usr/share/tomcat9/bin/catalina.sh start

tail -f /var/lib/tomcat9/logs/catalina.out -f /var/lib/openspecimen/data/logs/os.log
