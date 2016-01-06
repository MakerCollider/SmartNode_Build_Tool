CURR=`pwd`
LOG=$CURR/install.log

echo "updating mraa..."
opkg install $CURR/lib/mraa_0.9.0_i586.ipk
echo "done"

echo "updating upm..."
opkg install $CURR/lib/upm_0.4.1_i586.ipk
echo "done"

echo "cd /usr"
cd /usr

echo "install libuv..."
tar -xzvf $CURR/lib/libuv.bin.tgz >> $LOG
echo "done"

echo "install opencv..."
tar -xzvf $CURR/lib/OpenCV-3.0.0-rc1.tgz >> $LOG
echo "done"

echo "install libv4l..."
tar -xzvf $CURR/lib/libv4l.tgz >> $LOG
echo "done"

#echo "hacking mraa-diy library..."
#tar -xzvf $CURR/lib/mraa-diy.tgz >> $LOG
#echo "done"

#echo "hacking upm-diy library..."
#tar -xzvf $CURR/lib/upm-diy.tgz >> $LOG
#echo "done"

echo "run board auto detect tools"
cd ./edison_tools
./install_edisontools.sh
echo "done"

echo "install mqtt package..."
opkg install $CURR/lib/mqtt_1.4/*.ipk
echo "done"

echo "config mqtt..."
cp $CURR/lib/mqtt_1.4/mosquitto.conf /etc/mosquitto/
echo "done"

echo "cd /opt"
cd /opt

echo "install festival..."
tar -xzvf $CURR/lib/festival_prebuild.tar.gz >> $LOG
cd /opt/festival/festival/bin
cp festival /usr/bin
echo "done"

echo "import asound.conf..."                         
echo "pcm.!default sysdefault:Device" > /etc/asound.conf
echo "done"

cd $CURR
SERVICE=/etc/systemd/system/nodered.service
rm -rf $SERVICE
echo "[Unit]" > $SERVICE
echo "Description=Node-RED" >> $SERVICE
echo "" >> $SERVICE
echo "[Service]" >> $SERVICE
echo "Type=simple" >> $SERVICE
echo "Environment=\"NODE_PATH=/usr/lib/node_modules\"" >> $SERVICE
echo "ExecStart=/usr/bin/node $CURR/node-red/red.js --userDir $CURR/node-red -v" >> $SERVICE
echo "Restart=always" >> $SERVICE
echo "RestartSec=1" >> $SERVICE
echo "[Install]" >> $SERVICE
echo "WantedBy=multi-user.target" >> $SERVICE

sleep 2
echo "Disable Smart Node Service"
systemctl disable nodered

sleep 2
echo "Enable Smart Node Service"
systemctl enable nodered 

sleep 2                                                                                     
echo "Start Smart Node Service"                                                             
systemctl restart nodered > /dev/null 2>&1

echo "log saved to $LOG"
echo "The System will reboot in 5 seconds ..."
sleep 1
echo "The System will reboot in 4 seconds ..."
sleep 1
echo "The System will reboot in 3 seconds ..."
sleep 1
echo "The System will reboot in 2 seconds ..."
sleep 1
echo "The System will reboot in 1 seconds ..."
sleep 1
echo "Reboot ..."
reboot
