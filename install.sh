cat << "EOF"

            __  __       _                ____      _ _ _     _
           |  \/  | __ _| | _____ _ __   / ___|___ | | (_) __| | ___ _ __
           | |\/| |/ _` | |/ / _ \ '__| | |   / _ \| | | |/ _` |/ _ \ '__|
           | |  | | (_| |   <  __/ |    | |__| (_) | | | | (_| |  __/ |
           |_|  |_|\__,_|_|\_\___|_|     \____\___/|_|_|_|\__,_|\___|_|


EOF

CURR=`pwd`
LOG=$CURR/install.log

echo "## 1    ## Import configure"
cp $CURR/configure/asound.conf /etc/
cp $CURR/configure/asound.state /var/lib/alsa/
cp $CURR/configure/timesyncd.conf /etc/systemd/

echo "## 1.1  ## Apply configure"
alsactl restore
timedatectl set-timezone Asia/Hong_Kong

echo "## 2    ## Update mraa"
opkg install $CURR/lib/mraa_0.9.0_i586.ipk
echo "done"

echo "## 3    ## Update upm"
opkg install $CURR/lib/upm_0.4.1_i586.ipk
echo "done"

echo "## 4    ## Install git"
opkg install $CURR/lib/git_2.5.0-r0_core2-32.ipk

echo "## 5    ## Install opencv"
#opkg install $CURR/lib/libc6/libc6_2.20-r0.0_core2-32.ipk
#opkg install $CURR/lib/libc6/libc6-dev_2.20-r0.0_core2-32.ipk
#opkg install $CURR/lib/libc6/libc6-dbg_2.20-r0.0_core2-32.ipk
opkg install $CURR/lib/libjpeg/libjpeg8_8d+1.3.1-r0.0_core2-32.ipk
#opkg install $CURR/lib/libjpeg/libjpeg-dev_8d+1.3.1-r0.0_core2-32.ipk
#opkg install $CURR/lib/libjpeg/libjpeg-dbg_8d+1.3.1-r0.0_core2-32.ipk
opkg install $CURR/lib/libv4l/libv4l_1.0.1-r0.0_core2-32.ipk
opkg install $CURR/lib/libv4l/libv4l-dev_1.0.1-r0.0_core2-32.ipk
#opkg install $CURR/lib/libv4l/libv4l-dbg_1.0.1-r0.0_core2-32.ipk
opkg install $CURR/lib/OpenCV/opencv_3.0-r0_core2-32.ipk
opkg install $CURR/lib/OpenCV/opencv-link_3.0-r0_core2-32.ipk
opkg install $CURR/lib/OpenCV/opencv-dev_3.0-r0_core2-32.ipk
#opkg install $CURR/lib/OpenCV/opencv-dbg_3.0-r0_core2-32.ipk
opkg install $CURR/lib/OpenCV/opencv-staticdev_3.0-r0_core2-32.ipk

echo "## 6    ## Install sox"
#tar -xzvf $CURR/lib/sox.tar.gz -C /usr >> $LOG
opkg install $CURR/lib/libx264-133_r2265+git0+ffc3ad4945-r0_core2-32.ipk
opkg install $CURR/lib/libtheora_1.1.1-r1_core2-32.ipk
opkg install $CURR/lib/libavutil51_0.8.15-r0_core2-32.ipk
opkg install $CURR/lib/libavcodec53_0.8.15-r0_core2-32.ipk
opkg install $CURR/lib/libavformat53_0.8.15-r0_core2-32.ipk
opkg install $CURR/lib/libpng16-16_1.6.13-r0_core2-32.ipk
opkg install $CURR/lib/sox_14.4.0-r1_core2-32.ipk

echo "## 7    ## Install mpg123"
#tar -xzvf $CURR/lib/mpg123.tar.gz -C /usr >> $LOG
opkg install $CURR/lib/mpg123_1.22.4-r0_core2-32.ipk

echo "## 8    ## Install festival"
#tar -xzvf $CURR/lib/festival_prebuild.tar.gz -C /opt >> $LOG
#cp /opt/festival/festival/bin/festival /usr/bin
opkg install $CURR/lib/festival_2.3-r0_core2-32.ipk

echo "## 9    ## Hacking mraa-diy library"
tar -xzvf $CURR/lib/mraa-diy.tgz -C /usr >> $LOG
#cp -r /usr/lib/node_modules/mraa/mraa.node $CURR/node-red/node_modules/mraa/build/Release/

echo "## 10   ## Hacking upm-diy library"
tar -xzvf $CURR/lib/upm-diy.tgz -C /usr >> $LOG

echo "## 11   ## Run board auto detect tools"
cd $CURR/edison_tools
./install_edisontools.sh
cd $CURR

echo "## 12   ## Install mqtt package"
opkg install $CURR/lib/mqtt_1.4/*.ipk

echo "## 12.1 ## Config mqtt"
cp $CURR/lib/mqtt_1.4/mosquitto.conf /etc/mosquitto/

echo "## 13   ## Set smartnode service"
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

echo "## 13.1 ## Start smartnode service"
sleep 1
systemctl disable nodered
sleep 1
systemctl enable nodered 
sleep 1
systemctl restart nodered > /dev/null 2>&1

echo "## 14   ## All finish, log saved to $LOG"
