#!/bin/sh
TAR_NAME=smart_node_bitbake.tgz
echo $TAR_NAME
echo "make release package for edison image bitbake project ..."
rm -rf $TAR_NAME
tar -czvf $TAR_NAME -X ./package_exclude ../node-red/ ../Atlas/ ../install.sh ../install_for_dev.sh ../install_for_edibot.sh ../README.md

chmod 755 ./smart_node_bitbake.tgz

