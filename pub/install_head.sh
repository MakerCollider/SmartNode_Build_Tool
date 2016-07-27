#!/bin/sh

cat << "EOF"

            __  __       _                ____      _ _ _     _
           |  \/  | __ _| | _____ _ __   / ___|___ | | (_) __| | ___ _ __
           | |\/| |/ _` | |/ / _ \ '__| | |   / _ \| | | |/ _` |/ _ \ '__|
           | |  | | (_| |   <  __/ |    | |__| (_) | | | | (_| |  __/ |
           |_|  |_|\__,_|_|\_\___|_|     \____\___/|_|_|_|\__,_|\___|_|


EOF

CURR=`pwd`
LOG=$CURR/install.log

echo "## 0    ## Extract package"
line=`wc -l $0|awk '{print $1}'`
line=`expr $line - 26` 
rm -rf node-red/ lib/ configure/ edison_tools/ README.md install.sh sn_dev.sh
tail -n $line $0 |tar xzv >> $LOG
./install.sh
ret=$?
#
#
#
exit $ret
