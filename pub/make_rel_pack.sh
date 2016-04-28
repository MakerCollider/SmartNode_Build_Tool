#!/bin/sh
VERSION=$1
echo $VERSION
if  [ ! -n "$VERSION" ] ;then
    echo "USAGE: ./make_rel_pack.sh Version_number! etc. ./make_rel_pack.sh 0.9.5"
    exit
fi
TAR_NAME=smart_node.tgz
echo $TAR_NAME
echo "make release package..."
rm -rf $TAR_NAME
tar -czvf $TAR_NAME -X ./package_exclude ../node-red/ ../lib ../configure ../install.sh ../sn_dev.sh ../edison_tools ../README.md ../version

cat install_head.sh smart_node.tgz > SmartNode-$VERSION.install

chmod 755 SmartNode-${VERSION}.install

rm ./smart_node.tgz
