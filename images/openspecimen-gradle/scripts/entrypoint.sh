#!/bin/bash
echo "Starting Gradle Container for OpenSpecimen!"

file="/opt/dist/openspecimen.war"

if [[ ! -f "$file" ]]; then
  . /.profile
  . defaultvar.sh
  cd /opt
  wget -O openspec.zip "$RELEASEURL"
  unzip openspec.zip
  mv openspecimen-* openspecimen_build
  cd /opt/openspecimen_build/
  
  rm /opt/openspecimen_build/build.properties
  
  echo "app_home = <app_container_home>" >> /opt/openspecimen_build/build.properties
  echo "app_data_dir = <app_data_dir>" >> /opt/openspecimen_build/build.properties
  echo "app_log_conf =" >> /opt/openspecimen_build/build.properties
  echo "datasource_jndi = java:/comp/env/jdbc/openspecimen" >> /opt/openspecimen_build/build.properties
  echo "deployment_type = fresh" >> /opt/openspecimen_build/build.properties
  echo "" >> /opt/openspecimen_build/build.properties
  echo "database_type = mysql" >> /opt/openspecimen_build/build.properties
  echo "database_host = localhost" >> /opt/openspecimen_build/build.properties
  echo "database_port = 3306" >> /opt/openspecimen_build/build.properties
  echo "database_name = osdb" >> /opt/openspecimen_build/build.properties
  echo "database_username = root" >> /opt/openspecimen_build/build.properties
  echo "database_password = root" >> /opt/openspecimen_build/build.properties
  echo "" >> /opt/openspecimen_build/build.properties
  echo "show_sql = false" >> /opt/openspecimen_build/build.properties
  echo "" >> /opt/openspecimen_build/build.properties
  echo "plugin_dir = <path-to-directory-containing-plugin-jars>" >> /opt/openspecimen_build/build.properties
  
  sed -i "s#<app_container_home>#${APP_HOME}#g" /opt/openspecimen_build/build.properties
  sed -i "s#<app_data_dir>#${APP_DATA_DIR}#g" /opt/openspecimen_build/build.properties
  sed -i "s/database_host = localhost/database_host = ${DATABASE_HOST}/g" /opt/openspecimen_build/build.properties
  sed -i "s/database_name = osdb/database_name = ${MYSQL_DATABASE}/g" /opt/openspecimen_build/build.properties
  sed -i "s/database_username = root/database_username = ${MYSQL_USER}/g" /opt/openspecimen_build/build.properties
  sed -i "s/database_password = root/database_password = ${MYSQL_PASSWORD}/g" /opt/openspecimen_build/build.properties
  sed -i "s/app_log_conf =/app_log_conf = ${APP_LOG_CONF}/g" /opt/openspecimen_build/build.properties
  sed -i "s#datasource_jndi = java:/comp/env/jdbc/openspecimen#datasource_jndi = ${DATASOURCE_JNDI}#g" /opt/openspecimen_build/build.properties
  sed -i "s/deployment_type = fresh/deployment_type = ${DEVELOPMENT_TYPE}/g" /opt/openspecimen_build/build.properties
  sed -i "s/database_type = mysql/database_type = ${DATABASE_TYPE}/g" /opt/openspecimen_build/build.properties
  sed -i "s/database_port = 3306/database_port = ${DATABASE_PORT}/g" /opt/openspecimen_build/build.properties
  sed -i "s/show_sql = false/show_sql = ${SHOW_SQL}/g" /opt/openspecimen_build/build.properties
  sed -i "s#<path-to-directory-containing-plugin-jars>#${PLUGIN_DIR}#g" /opt/openspecimen_build/build.properties
  
  cd /opt/openspecimen_build/www
  npm install
  bower install --allow-root
  cd /opt/openspecimen_build
  gradle build --stacktrace --debug
  mv /opt/openspecimen_build/build/libs/openspecimen.war "$file"
  
  #Cleanup
  apt-get clean
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  rm /opt/openspec.zip
  rm -r /opt/openspecimen_build
fi