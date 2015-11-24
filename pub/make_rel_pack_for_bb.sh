#!/bin/sh
TAR_NAME=smart_node_bitbake.tgz
echo $TAR_NAME
echo "make release package for edison image bitbake project ..."
rm -rf $TAR_NAME

mkdir SmartNode

SERVICE=./SmartNode/nodered.service
rm -rf $SERVICE
echo "[Unit]" > $SERVICE
echo "Description=Node-RED" >> $SERVICE
echo "" >> $SERVICE
echo "[Service]" >> $SERVICE
echo "Type=simple" >> $SERVICE
echo "Environment=\"NODE_PATH=/usr/lib/node_modules\"" >> $SERVICE
echo "ExecStart=/usr/bin/node /home/root/SmartNode/node-red/red.js --userDir /home/root/SmartNode/node-red -v" >> $SERVICE
echo "Restart=always" >> $SERVICE
echo "RestartSec=1" >> $SERVICE
echo "[Install]" >> $SERVICE
echo "WantedBy=multi-user.target" >> $SERVICE

cp ../nodered.service SmartNode/
cp -r ../node-red/ SmartNode/
cp -r ../Atlas/ SmartNode/
cp ../install.sh SmartNode/
cp ../install_for_dev.sh SmartNode/
cp ../install_for_edibot.sh SmartNode/
cp ../README.md SmartNode/

tar -czvf $TAR_NAME  ./SmartNode

chmod 755 ./smart_node_bitbake.tgz

rm -rf SmartNode/

