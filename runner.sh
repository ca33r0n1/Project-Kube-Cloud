#!/bin/sh
echo "Starting Server Install Script"
wget --no-check-certificate -O installer.sh "https://${weburl}/MPL-Server/Scripts/${servergroup}/install.sh"
chmod +x "installer.sh"
/bin/sh  -c "/data/installer.sh ${jenkinskey}"
