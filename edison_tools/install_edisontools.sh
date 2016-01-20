#!/bin/sh
echo "Installing Edison extension board check tool."
cp extboardcheck.sh /etc/
cp all_built/check5611 /usr/bin
cp all_built/check6050 /usr/bin
cp all_built/check5883 /usr/bin
cp all_built/mraaio /usr/bin

systemctl disable extboard_detect
cp extboard_detect.service /etc/systemd/system/
echo "Enabling Edison extension board check tool start up."
systemctl enable extboard_detect
systemctl start extboard_detect
echo "All done."
