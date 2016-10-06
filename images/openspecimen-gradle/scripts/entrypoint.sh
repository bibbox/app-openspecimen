#!/bin/bash
echo "Starting Gradle Container for OpenSpecimen!"

file="/opt/dist/openspecimen.war"

if [[ ! -f "$file" ]]; then
  . /.profile
  cd /opt
  wget -O openspec.zip "$RELEASEURL"
  unzip openspec.zip
  mv openspecimen* openspecimen
  cd /opt/openspecimen/
  
  sed -i "s#<app_container_home>#/opt/tomcat#g" /opt/openspecimen/build.properties
  sed -i "s#<app_data_dir>#/opt/openspecimen/os-data#g" /opt/openspecimen/build.properties
  sed -i "s/database_host = localhost/database_host = openspecimen-db-${INSTANCE}/g" /opt/openspecimen/build.properties
  sed -i "s/database_name = osdb/database_name = ${MYSQL_DATABASE}/g" /opt/openspecimen/build.properties
  sed -i "s/database_username = root/database_username = ${MYSQL_USER}/g" /opt/openspecimen/build.properties
  sed -i "s/database_password = root/database_password = ${MYSQL_PASSWORD}/g" /opt/openspecimen/build.properties
  sed -i "s#<path-to-directory-containing-plugin-jars>#/opt/openspecimen/os-plugins#g" /opt/openspecimen/build.properties
  
  cd /opt/openspecimen/www
  npm install
  bower install --allow-root
  cd /opt/openspecimen
  gradle build
  mv /opt/openspecimen/build/libs/openspecimen.war "$file"
  
  #Cleanup
  apt-get clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  rm /opt/openspec.zip
  rm -r /opt/openspecimen
fi