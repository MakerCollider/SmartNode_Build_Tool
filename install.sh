CURR=`pwd`
LOG=$CURR/install.log

echo "import configure..."
cp $CURR/configure/asound.conf /etc/
cp $CURR/configure/asound.state /var/lib/alsa/
cp $CURR/configure/timesyncd.conf /etc/systemd/

alsactl restore
timedatectl set-timezone Asia/Hong_Kong
echo "done"

echo "updating mraa..."
opkg install $CURR/lib/mraa_0.9.0_i586.ipk
echo "done"

echo "updating upm..."
opkg install $CURR/lib/upm_0.4.1_i586.ipk
echo "done"

echo "install git"
opkg install $CURR/lib/git_2.5.0-r0_core2-32.ipk

echo "install opencv..."
opkg install $CURR/lib/OpenCV/opencv_3.0-r0_core2-32.ipk >> $LOG
opkg install $CURR/lib/OpenCV/opencv-dev_3.0-r0_core2-32.ipk >> $LOG
opkg install $CURR/lib/OpenCV/opencv-dbg_3.0-r0_core2-32.ipk >> $LOG
opkg install $CURR/lib/OpenCV/opencv-staticdev_3.0-r0_core2-32.ipk >> $LOG
opkg install $CURR/lib/OpenCV/opencv-link_3.0-r0_core2-32.ipk >> $LOG
echo "done"

echo "cd /usr"
cd /usr

echo "install sox..."
tar -xzvf $CURR/lib/sox.tar.gz >> $LOG
echo "done"

echo "install mpg123..."
tar -xzvf $CURR/lib/mpg123.tar.gz >> $LOG
echo "done"

echo "hacking mraa-diy library..."
tar -xzvf $CURR/lib/mraa-diy.tgz >> $LOG
cp -r /usr/lib/node_modules/mraa/mraa.node $CURR/node-red/node_modules/mraa/build/Release/
echo "done"

echo "hacking upm-diy library..."
tar -xzvf $CURR/lib/upm-diy.tgz >> $LOG
echo "done"

echo "run board auto detect tools"
cd $CURR/edison_tools
./install_edisontools.sh
cd ../
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
