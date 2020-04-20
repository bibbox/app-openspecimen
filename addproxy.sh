#!/bin/bash

# addproxy script
# BIBBOX shell script
# http://bibbox.org
#
# This script will create an proxy entry for a Apache2 debian ionstallation

PROGNAME=$(basename $0)

usage()
{
    echo "Usage:    addproxy [OPTIONS]"
    echo "          addproxy [ --help | -v | --version ]"
    echo ""
    echo "Creates Proxy entry for tool"
    echo ""
    echo "OPTIONS:"
    echo "      -t, --instance                  Unique name of the tool"
    echo ""
    echo "Example:"
    echo "       sudo ./addproxy.sh -t test -s subtest -p 7867 -i 127.0.0.1"
}

version()
{
  echo "Version: 1.0"
  echo "BIBBOX Version: 1.0"
  echo "Build: 2016-07-06"
}

clean_up() {
	exit $1
}

error_exit()
{
	echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	clean_up 1
}

createProxyfile()
{
    if [ -e /etc/apache2/sites-available ]; then
        echo "Create proxy file /etc/apache2/sites-available/005-$instance.conf"
    else
        error_exit "$LINENO: Directory sites-available from apache2 not available! Aborting."
    fi
    
cat > /etc/apache2/sites-available/005-$instance.conf <<EOF
<VirtualHost *:80>
        ServerName $subdomain.$url
        <Proxy *>
                        Order deny,allow
                        Allow from all
        </Proxy>

        ProxyRequests           Off
        ProxyPreserveHost On
        ProxyPass               /       http://$ip:$port/
        ProxyPassReverse        /       http://$ip:$port/
</VirtualHost>
EOF
}

linkfile()
{
  ln -s /etc/apache2/sites-available/005-$instance.conf /etc/apache2/sites-enabled/005-$instance.conf
}

ip=127.0.0.1
url=demo.bibbox.org

while [ "$1" != "" ]; do
    case $1 in
        -i | --instance )       shift
                                instance=$1
                                ;;
        -s | --subdomain )      shift
                                subdomain=$1
                                ;;
        -p | --port )           shift
                                port=$1
                                ;;
        -i | --ip )             shift
                                ip=$1
                                ;;
        -u | --url )            shift
                                url=$1
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

createProxyfile
linkfile
clean_up