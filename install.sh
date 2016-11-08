#!/bin/bash
echo "Installing OpenSpecimen BIBBOX Application"
echo "installing from $PWD"

folder="/opt/bibbox/application-instance/app-openspecimen-instance"
instance="instance"

PROGNAME=$(basename $0)

usage()
{
    echo "Usage:    start [OPTIONS]"
    echo "          start [ --help | -v | --version ]"
    echo ""
    echo "Creates Instance of the compose docker file"
    echo ""
    echo "OPTIONS:"
    echo "      -i, --instance                  Instance ID"
    echo ""
    echo "Example:"
    echo "       sudo ./start.sh -i instance1"
    echo ""
}

version()
{
  echo "Version: 1.1"
  echo "BIBBOX Version: 1.0"
  echo "Build: 2016-10-24"
}

clean_up() {	
	exit $1
}

error_exit()
{
	echo "ERROR in ${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	clean_up 1
}

updateConfigurationFile()
{
    echo "Creat and Update config files"
    if [[ ! -f "$folder/config/openspecimen.cnf" ]]; then
        cp config/openspecimen.cnf "$folder/config/openspecimen.cnf"
    fi
    if  [[ ! -f "$folder/docker-compose.yml" ]]; then
        cp docker-compose.yml "$folder/docker-compose.yml"
    fi
    
    sed -i "s/§§INSTANCE/${instance}/g" "$folder/docker-compose.yml"
    sed -i "s#§§FOLDER#${folder}#g" "$folder/docker-compose.yml"
    sed -i "s/§§PORT/${port}/g" "$folder/docker-compose.yml"
    sed -i "s#§§MYSQL_ROOT_PASSWORD#${MYSQL_ROOT_PASSWORD}#g" "$folder/docker-compose.yml"
    sed -i "s/§§MYSQL_DATABASE/${MYSQL_DATABASE}/g" "$folder/docker-compose.yml"
    sed -i "s/§§MYSQL_USER/${MYSQL_USER}/g" "$folder/docker-compose.yml"
    sed -i "s#§§MYSQL_PASSWORD#${MYSQL_PASSWORD}#g" "$folder/docker-compose.yml"
    sed -i "s/§§TOMCAT_MANAGER_USER/${TOMCAT_MANAGER_USER}/g" "$folder/docker-compose.yml"
    sed -i "s#§§TOMCAT_MANAGER_PASSWORD#${TOMCAT_MANAGER_PASSWORD}#g" "$folder/docker-compose.yml"
    sed -i "s/§§INSTITUTE_NAME/${INSTITUTE_NAME}/g" "$folder/docker-compose.yml"
    sed -i "s/§§EMAIL_ADDRESS/${EMAIL_ADDRESS}/g" "$folder/docker-compose.yml"
    sed -i "s/§§FIRST_NAME/${FIRST_NAME}/g" "$folder/docker-compose.yml"
    sed -i "s/§§LAST_NAME/${LAST_NAME}/g" "$folder/docker-compose.yml"
    sed -i "s/§§LOGIN_NAME/${LOGIN_NAME}/g" "$folder/docker-compose.yml"
    sed -i "s/§§ADDRESS/${ADDRESS}/g" "$folder/docker-compose.yml"
}

createFolders()
{
    if [[ ! -d "$folder" ]]; then
        echo "Creating Installation Folder"
        mkdir -p "$folder/config"
        mkdir -p "$folder/data/mysql"
        mkdir -p "$folder/data/dist"
        mkdir -p "$folder/data/os-data"
        mkdir -p "$folder/data/os-plugins"
    fi
}

checkParameters() 
{
    echo "Setup parameters:"
    if [[ "$instance" = "instance" ]]; then
        echo "No instance id set! Using default." 
    else
        echo "Instance: $instance" 
    fi
    
    if [[ "$folder" = "/opt/bibbox/application-instance/app-openspecimen-instance" ]]; then
        echo "No installation folder set! Using default."
    else
        echo "Installation Folder: $folder" 
    fi
    
    if [[ -z "$port" ]]; then
        usage
        error_exit "The port is not set."
    else
        echo "Port: $port"
    fi
    
    if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
        echo "Mysql root passwort not set, creating random password."
        MYSQL_ROOT_PASSWORD=$(LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\%\^\&\*\(\)-+= < /dev/urandom | head -c 32 | xargs)
    else
        echo "Mysql root passwort: ****"
    fi
    
    if [[ -z "$MYSQL_DATABASE" ]]; then
        echo "Database not set, setting default: openspecimen"
        MYSQL_DATABASE="openspecimen"
    else
        echo "MYSQL_DATABASE: $MYSQL_DATABASE"
    fi
    
    if [[ -z "$MYSQL_USER" ]]; then
        echo "Mysql User not set"
    else
        echo "MYSQL_USER: $MYSQL_USER"
    fi
    
    if [[ -z "$MYSQL_PASSWORD" ]]; then
        echo "Mysql password not set, creating random password."
        MYSQL_PASSWORD=$(LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\%\^\&\*\(\)-+= < /dev/urandom | head -c 32 | xargs)
    else
        echo "MYSQL_PASSWORD: ****"
    fi
    
    if [[ -z "$TOMCAT_MANAGER_USER" ]]; then
        echo "Tomcat manager user not set"
    else
        echo "TOMCAT_MANAGER_USER: $TOMCAT_MANAGER_USER"
    fi
    
    if [[ -z "$TOMCAT_MANAGER_PASSWORD" ]]; then
        echo "Tomcat manager password not set, creating random password."
        TOMCAT_MANAGER_PASSWORD=$(LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\%\^\&\*\(\)-+= < /dev/urandom | head -c 32 | xargs)
    else
        echo "TOMCAT_MANAGER_PASSWORD: ****"
    fi  
    
    if [[ -z "$EMAIL_ADDRESS" ]]; then
        echo "email address for openspecimen user not set"
    else
        echo "EMAIL_ADDRESS: $EMAIL_ADDRESS"
    fi
    
    if [[ -z "$FIRST_NAME" ]]; then
        echo "First name for openspecimen user not set"
    else
        echo "FIRST_NAME: $FIRST_NAME"
    fi
    
    if [[ -z "$LAST_NAME" ]]; then
        echo "Last name for openspecimen user not set"
    else
        echo "LAST_NAME: $LAST_NAME"
    fi
    
    if [[ -z "$LOGIN_NAME" ]]; then
        echo "Login user name for openspecimen user not set"
    else
        echo "LOGIN_NAME: $LOGIN_NAME"
    fi
    
    if [[ -z "$ADDRESS" ]]; then
        echo "address for openspecimen user not set"
    else
        echo "ADDRESS: $ADDRESS"
    fi
}

while [ "$1" != "" ]; do
    case $1 in
        -i | --instance )       shift
                                instance=$1
                                ;;
        -f | --folder )         shift
                                folder=$1
                                ;;
        -p | --port )           shift
                                port=$1
                                ;;
        --MYSQL_ROOT_PASSWORD ) shift
                                MYSQL_ROOT_PASSWORD=$1
                                ;;
        --mysqldatabase )       shift
                                MYSQL_DATABASE=$1
                                ;;
        --MYSQL_USER )          shift
                                MYSQL_USER=$1
                                ;;
        --MYSQL_PASSWORD )      shift
                                MYSQL_PASSWORD=$1
                                ;;
        --TOMCAT_MANAGER_USER ) shift
                                TOMCAT_MANAGER_USER=$1
                                ;;
        --TOMCAT_MANAGER_PASSWORD ) shift
                                TOMCAT_MANAGER_PASSWORD=$1
                                ;;
        --INSTITUTE_NAME )      shift
                                INSTITUTE_NAME=$1
                                ;;
        --EMAIL_ADDRESS )       shift
                                EMAIL_ADDRESS=$1
                                ;;
        --FIRST_NAME )          shift
                                FIRST_NAME=$1
                                ;;
        --LAST_NAME )           shift
                                LAST_NAME=$1
                                ;;
        --LOGIN_NAME )          shift
                                LOGIN_NAME=$1
                                ;;
        --ADDRESS )             shift
                                ADDRESS=$1
                                ;;
        -h | --help )           usage
                                clean_up
                                ;;
        -v | --version | version )  version
                                clean_up
                                ;;
        * )                     usage
                                error_exit "Parameters not matching"
    esac
    shift
done

checkParameters
createFolders
updateConfigurationFile