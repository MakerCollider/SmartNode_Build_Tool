#!/bin/sh

cat << "EOF"

              ____                       _     _   _           _      
             / ___| _ __ ___   __ _ _ __| |_  | \ | | ___   __| | ___ 
             \___ \| '_ ` _ \ / _` | '__| __| |  \| |/ _ \ / _` |/ _ \
              ___) | | | | | | (_| | |  | |_  | |\  | (_) | (_| |  __/
             |____/|_| |_| |_|\__,_|_|   \__| |_| \_|\___/ \__,_|\___|

            Copyright (C) 2015-2016, Maker Collider, All Rights Reserved.

EOF

CURR=`pwd`
LOG=$CURR/install.log

echo "## 0    ## Extract package"
line=`wc -l $0|awk '{print $1}'`
line=`expr $line - 27` 
rm -rf node-red/ lib/ configure/ edison_tools/ README.md install.sh sn_dev.sh
tail -n $line $0 |tar xzv >> $LOG
./install.sh
ret=$?
#
#
#
exit $ret
