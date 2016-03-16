#!/bin/bash

cat << "EOF"

            __  __       _                ____      _ _ _     _
           |  \/  | __ _| | _____ _ __   / ___|___ | | (_) __| | ___ _ __
           | |\/| |/ _` | |/ / _ \ '__| | |   / _ \| | | |/ _` |/ _ \ '__|
           | |  | | (_| |   <  __/ |    | |__| (_) | | | | (_| |  __/ |
           |_|  |_|\__,_|_|\_\___|_|     \____\___/|_|_|_|\__,_|\___|_|


EOF

CMD=`pwd`
NODE_PATH="node-red/node_modules"
SMART_GIT="https://github.com/MakerCollider/node-red-contrib-smartnode-hook.git"
HOOK_GIT="https://github.com/MakerCollider/node-red-contrib-smartnode-hook.git"
SEEED_GIT="https://github.com/MakerCollider/node-red-contrib-smartnode-hook.git"
DFROBOT_GIT="https://github.com/MakerCollider/node-red-contrib-smartnode-hook.git"

echo "## 1    ## Stop node-red service"
systemctl stop nodered

echo "## 2    ## Clone latest repository from Github"
rm -rf node-red/node_modules/node-red-contrib-smartnode*
git clone ${SMART_GIT} ${CMD}/${NODE_PATH}/node-red-contrib-smartnode
git clone ${HOOK_GIT} ${CMD}/${NODE_PATH}/node-red-contrib-smartnode-hook
git clone ${SEEED_GIT} ${CMD}/${NODE_PATH}/node-red-contrib-smartnode-seeed
git clone ${DFROBOT_GIT} ${CMD}/${NODE_PATH}/node-red-contrib-smartnode-dfrobot

echo "## 3    ## Add soft link"
rm -rf link && mkdir link
ln -s ../${NODE_PATH}/node-red-contrib-smartnode ${CMD}/link/smartnode
ln -s ../${NODE_PATH}/node-red-contrib-smartnode-hook ${CMD}/link/smartnode-hook
ln -s ../${NODE_PATH}/node-red-contrib-smartnode-dfrobot ${CMD}/link/smartnode-dfrobot
ln -s ../${NODE_PATH}/node-red-contrib-smartnode-seeed ${CMD}/link/smartnode-seeed

echo "## 4    ## Restart node-red service"
systemctl start nodered

echo "## 5    ## All finish"