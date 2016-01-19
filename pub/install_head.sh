#!/bin/sh
CURR=`pwd`
LOG=$CURR/install.log

echo "Extract package......"
line=`wc -l $0|awk '{print $1}'`
line=`expr $line - 15` 
rm -r io-js/ Atlas/ node-red/ lib/ /configure/ edison_tools/ README.md install.sh install_for_dev.sh  
tail -n $line $0 |tar xzv >> $LOG
echo "Done!"
./install.sh
ret=$?
#
#
#
exit $ret
