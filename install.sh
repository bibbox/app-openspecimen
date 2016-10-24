#!/bin/bash
echo "Installing OpenSpecimen BIBBOX Application"
echo "installing from $PWD"

folder="/opt/bibbox/application-instance/app-openspecimen-instance"
instance="instance"

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
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
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
    sed -i "s/§§FOLDER/${folder}/g" "$folder/docker-compose.yml"


§§MYSQL_ROOT_PASSWORD
§§MYSQL_DATABASE
§§MYSQL_USER
§§MYSQL_PASSWORD
§§TOMCAT_MANAGER_USER
§§TOMCAT_MANAGER_PASSWORD
§§INSTITUTE_NAME
§§EMAIL_ADDRESS
§§FIRST_NAME
§§LAST_NAME
§§LOGIN_NAME
§§ADDRESS
      
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
}

while [ "$1" != "" ]; do
    case $1 in
        -i | --instance )       shift
                                instance=$1
                                ;;
        -f | --folder )         shift
                                folder=$1
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