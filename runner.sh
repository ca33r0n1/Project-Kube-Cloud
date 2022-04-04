#!/bin/sh
echo "Starting Server Install Script"
wget --no-check-certificate --quiet -O installer.sh "https://${weburl}/${servergroup}/${servertype}-install.sh"
chmod +x "installer.sh"
/bin/sh  -c "/data/installer.sh ${jenkinskey}"
