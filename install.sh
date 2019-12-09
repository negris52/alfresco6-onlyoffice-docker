#!/bin/bash

INSTALL_PATH='';

read_installation_method () {
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "\e[92mSpecify your domain name where you want to install Alfresco + ONLYOFFICE docker compose"
	echo "'testdomain.com' for example or input 'C' to cancel installation."
	echo "Please note, that you need to obtain valid CA-signed SSL certificate for your domain"
	echo "Name your certificate 'server.crt', your private key 'server.key' and put them in same dir with install.sh script"
	echo "Make sure you installed Docker and Docker Compose, use these guides if needed:"
	echo "https://docs.docker.com/install/linux/docker-ce/ubuntu/"
	echo "https://docs.docker.com/compose/install/"
	echo "This installation needs some time to complete, it was tested on Ubuntu 18.04, please be patient!"
        echo -e "\e[0m~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	read -p "[domain_name/C]? " choice
	case "$choice" in
		c|C )
			exit 0;
		;;
		* )
			INSTALL_PATH="$choice";
		;;
	esac
}

file_exist_check () {
if [ -f "$FILE" ]; then
        echo "$FILE exist"
	if [[ "$FILE" == server.crt ]]; then
		cp server.crt /app/onlyoffice/documentserver/data/certs/onlyoffice.crt;
		cp server.crt ./https/assets;
		cp server.crt ./https/assets/CA.pem;
	fi
	if [[ "$FILE" == server.key ]]; then
		cp server.key /app/onlyoffice/documentserver/data/certs/onlyoffice.key;
		cp server.key ./https/assets;
        fi

else
        echo "$FILE does not exist, please check it and run install.sh again";
        exit 0;
fi
}

read_installation_method
sed -i "s/your_domain/$INSTALL_PATH/g" ./alfresco/Dockerfile
sed -i "s/your_domain/$INSTALL_PATH/g" ./https/assets/alfresco-vhost.conf
mkdir -p /app/onlyoffice/documentserver/data/certs
FILE=server.crt
file_exist_check
FILE=server.key
file_exist_check
sleep 3
docker-compose up
