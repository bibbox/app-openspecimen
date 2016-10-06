#!/bin/bash
echo "Starting OpenSpecimen Containers"

folder="/Users/mue/dockerdata/openspecimen"
instance="DEV"

usage()
{
    echo "Usage:    start [OPTIONS]"
    echo "          start [ --help | -v | --version ]"
    echo ""
    echo "Creates Instance of the compose docker file"
    echo ""
    echo "OPTIONS:"
    echo "      -i, --instance                  Instance Name"
    echo ""
    echo "Example:"
    echo "       sudo ./start.sh -i instance1"
}

version()
{
  echo "Version: 1.0"
  echo "BIBBOX Version: 1.0"
  echo "Build: 2016-08-12"
}

clean_up() {

	# Perform program exit housekeeping
	# Optionally accepts an exit status
	
	exit $1
}

error_exit()
{
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	clean_up 1
}

checkConfig()
{

    echo "check config"
    if [[ ! -d "$folder" ]]; then
        mkdir -p "$folder/var/lib/mysql"
        mkdir -p "$folder/etc/mysql/conf.d"
    
        cp config/openspecimen.cnf "$folder/etc/mysql/conf.d/openspecimen.cnf"
    fi
}

checkParameters() 
{
    if [[ "$instance" = "instance" ]]; then
        echo "No seperate instance name set!"
    fi
}


checkConfig

while [ "$1" != "" ]; do
    case $1 in
        -i | --instance )       shift
                                instance=$1
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


# TODO
# Add possibility to set instance name
# Copy compose file to instanc folder
# add config file from container to seperate config file

# Run in DB
# insert into catissue_institution (identifier, name, activity_status) values (default, '<institution name>', 'Active')
# insert into os_departments (identifier, name, institute_id) values (default, '<department name>', '<ID of institute created in above step>')
# insert into catissue_user
#  (identifier, email_address, first_name, last_name, login_name, activity_status, institute_id,
#   password, domain_name, is_admin, address)
#values
#  (default, '<email address>', '<first name>', '<last name>', '<login name>', 'Active', '<institute_id created above>',
#   '$2a$10$GOH1.KmElP0ZusLYS6l12ejO.xAIzDUFpIm7LVz9xAcrObyvd3gLC', 'openspecimen', 1, '<address>');
# password will be Login!@3