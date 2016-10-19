#!/bin/bash
echo "Starting Gradle Container for OpenSpecimen!"

file="/opt/dist/openspecimen.war"

if [[ ! -f "$file" ]]; then
  . /.profile
  . defaultvar.sh
  cd /opt
  wget -O openspec.zip "$RELEASEURL"
  unzip openspec.zip
  mv openspecimen* openspecimen
  cd /opt/openspecimen/
  
  sed -i "s#<app_container_home>#${APP_HOME}#g" /opt/openspecimen/build.properties
  sed -i "s#<app_data_dir>#${APP_DATA_DIR}#g" /opt/openspecimen/build.properties
  sed -i "s/database_host = localhost/database_host = ${DATABASE_HOST}${INSTANCE}/g" /opt/openspecimen/build.properties
  sed -i "s/database_name = osdb/database_name = ${MYSQL_DATABASE}/g" /opt/openspecimen/build.properties
  sed -i "s/database_username = root/database_username = ${MYSQL_USER}/g" /opt/openspecimen/build.properties
  sed -i "s/database_password = root/database_password = ${MYSQL_PASSWORD}/g" /opt/openspecimen/build.properties
  sed -i "s/app_log_conf =/app_log_conf = ${APP_LOG_CONF}/g" /opt/openspecimen/build.properties
  sed -i "s#datasource_jndi = java:/comp/env/jdbc/openspecimen#datasource_jndi = ${DATASOURCE_JNDI}#g" /opt/openspecimen/build.properties
  sed -i "s/deployment_type = fresh/deployment_type = ${DEVELOPMENT_TYPE}/g" /opt/openspecimen/build.properties
  sed -i "s/database_type = mysql/database_type = ${DATABASE_TYPE}/g" /opt/openspecimen/build.properties
  sed -i "s/database_port = 3306/database_port = ${DATABASE_PORT}/g" /opt/openspecimen/build.properties
  sed -i "s/show_sql = false/show_sql = ${SHOW_SQL}/g" /opt/openspecimen/build.properties
  sed -i "s#<path-to-directory-containing-plugin-jars>#${PLUGIN_DIR}#g" /opt/openspecimen/build.properties
  
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