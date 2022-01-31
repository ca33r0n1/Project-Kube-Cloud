#!/bin/sh
echo "Starting Server Install Script"
wget -O installer.sh "https://${weburl}/${servergroup}/${servertype}-install.sh"
/bin/sh  -c "/data/installer.sh ${jenkinskey}"