#!/bin/sh

CURR=`pwd`
LOG=$CURR/install.log

echo "## 1    ## Import configure"
ASOUND=/etc/asound.conf
echo "defaults.pcm.card 2" > $ASOUND
#cp $CURR/configure/asound.conf /etc/
#cp $CURR/configure/asound.state /var/lib/alsa/
#cp $CURR/configure/timesyncd.conf /etc/systemd/
#cp $CURR/configure/mosquitto.conf /etc/mosquitto/

echo "## 1.1  ## Apply configure(disabled)"
#amixer -c 2 set Speaker 100%
#alsactl store
#timedatectl set-timezone Asia/Hong_Kong
#systemctl restart mosquitto

echo "## 2    ## Update mraa(disabled)"
#opkg install $CURR/lib/mraa_0.9.0_i586.ipk

echo "## 3    ## Update upm(disabled)"
#opkg install $CURR/lib/upm_0.4.1_i586.ipk

echo "## 4    ## Install git(disabled)"
#opkg install $CURR/lib/git_2.5.0-r0_core2-32.ipk

echo "## 5    ## Install opencv"
#opkg install $CURR/lib/opencv/libpng16-16_1.6.13-r0_core2-32.ipk
opkg install $CURR/lib/opencv/libpng16-dev_1.6.13-r0_core2-32.ipk
opkg install $CURR/lib/opencv/libgif4_4.1.6-r3_core2-32.ipk
opkg install $CURR/lib/opencv/libgif-dev_4.1.6-r3_core2-32.ipk
opkg install $CURR/lib/opencv/libtiff5_4.0.3-r0_core2-32.ipk
opkg install $CURR/lib/opencv/libtiff-dev_4.0.3-r0_core2-32.ipk
opkg install $CURR/lib/opencv/libv4l_1.0.1-r0_core2-32.ipk
opkg install $CURR/lib/opencv/libv4l-dev_1.0.1-r0_core2-32.ipk
opkg install $CURR/lib/opencv/libwebp_0.4.0-r0_core2-32.ipk
opkg install $CURR/lib/opencv/libwebp-dev_0.4.0-r0_core2-32.ipk
opkg install $CURR/lib/opencv/v4l-utils_1.0.1-r0_core2-32.ipk
opkg install $CURR/lib/opencv/v4l-utils-dev_1.0.1-r0_core2-32.ipk
sh $CURR/lib/opencv/OpenCV-3.1.0-1017-g52444bf-i686.sh --prefix=/usr --exclude-subdir

echo "## 6    ## Install sox"
#tar -xzvf $CURR/lib/sox.tar.gz -C /usr >> $LOG
opkg install $CURR/lib/sox/libx264-133_r2265+git0+ffc3ad4945-r0_core2-32.ipk
opkg install $CURR/lib/sox/libtheora_1.1.1-r1_core2-32.ipk
opkg install $CURR/lib/sox/libavutil51_0.8.15-r0_core2-32.ipk
opkg install $CURR/lib/sox/libavcodec53_0.8.15-r0_core2-32.ipk
opkg install $CURR/lib/sox/libavformat53_0.8.15-r0_core2-32.ipk
#opkg install $CURR/lib/sox/libpng16-16_1.6.13-r0_core2-32.ipk
opkg install $CURR/lib/sox/sox_14.4.0-r1_core2-32.ipk

echo "## 7    ## Install mpg123"
#tar -xzvf $CURR/lib/mpg123.tar.gz -C /usr >> $LOG
opkg install $CURR/lib/mpg123/mpg123_1.22.4-r0_core2-32.ipk

echo "## 8    ## Install festival"
#tar -xzvf $CURR/lib/festival_prebuild.tar.gz -C /opt >> $LOG
#cp /opt/festival/festival/bin/festival /usr/bin
opkg install $CURR/lib/festival/festival_2.3-r0_core2-32.ipk

echo "## 9    ## Hacking mraa-diy library"
opkg remove mraa mraa-dev --force-depends
tar -xzvf $CURR/lib/mraa-diy.tgz -C /usr >> $LOG
#cp -r /usr/lib/node_modules/mraa/mraa.node $CURR/node-red/node_modules/mraa/build/Release/

echo "## 10   ## Hacking upm-diy library"
tar -xzvf $CURR/lib/upm-diy.tgz -C /usr >> $LOG

echo "## 11   ## Run board auto detect tools"
cd $CURR/edison_tools
./install_edisontools.sh
cd $CURR

echo "## 12   ## Install mqtt package(disabled)"
#opkg install $CURR/lib/mqtt_1.4/*.ipk

echo "## 12.1 ## Config mqtt(disabled, move to stage 1.1)"
#cp $CURR/lib/mqtt_1.4/mosquitto.conf /etc/mosquitto/

echo "## 13   ## Add showip service"
mkdir -p /etc/init.d
cp $CURR/lib/showip/showip /etc/init.d
chmod 755 /etc/init.d/showip
update-rc.d -f showip remove
update-rc.d showip defaults 91

echo "## 14   ## Set smartnode service"
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

echo "## 14.1 ## Start smartnode service"
sleep 1
systemctl disable nodered
sleep 1
systemctl enable nodered 
sleep 1
systemctl restart nodered > /dev/null 2>&1

echo "## 15   ## All finish, log saved to $LOG"