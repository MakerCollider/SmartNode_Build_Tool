#!/bin/sh
TAR_NAME=smartnode_1.0.tar.gz
echo $TAR_NAME
echo "make release package for edison image bitbake project ..."
rm -rf $TAR_NAME

TARDIR=smartnode_1.0
mkdir $TARDIR

SERVICE=./$TARDIR/nodered.service
rm -rf $SERVICE
echo "[Unit]" > $SERVICE
echo "Description=Node-RED" >> $SERVICE
echo "" >> $SERVICE
echo "[Service]" >> $SERVICE
echo "Type=simple" >> $SERVICE
echo "Environment=\"NODE_PATH=/usr/lib/node_modules\"" >> $SERVICE
echo "ExecStart=/usr/bin/node /home/root/$TARDIR/node-red/red.js --userDir /home/root/TARDIR/node-red -v" >> $SERVICE
echo "Restart=always" >> $SERVICE
echo "RestartSec=1" >> $SERVICE
echo "[Install]" >> $SERVICE
echo "WantedBy=multi-user.target" >> $SERVICE

cp ../nodered.service ./$TARDIR
cp -r ../node-red/ ./$TARDIR
cp -r ../Atlas/ ./$TARDIR
cp ../install.sh ./$TARDIR
cp ../install_for_dev.sh ./$TARDIR
cp ../install_for_edibot.sh ./$TARDIR
cp ../README.md ./$TARDIR

tar -czvf $TAR_NAME  ./$TARDIR

chmod 755 ./$TAR_NAME

rm -rf ./$TARDIR

