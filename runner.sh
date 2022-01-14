#!/bin/sh
echo "Starting Server Install Script"
wget -O installer.sh "https://$1/$2/$3-install.sh"
/bin/sh /data/installer.sh "$4"