#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

# git submodule init
# git submodule sync
# git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

# CONFLINE="MACHINE = \"qemuarm64\""
CONFLINE="MACHINE = \"raspberrypi3-64\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi


# bitbake-layers show-layers | grep "meta-aesd" > /dev/null
# layer_info=$?

# if [ $layer_info -ne 0 ];then
# 	echo "Adding meta-aesd layer"
# 	bitbake-layers add-layer ../meta-aesd
# else
# 	echo "meta-aesd layer already exists"
# fi

# Function to check and add layers
check_and_add_layer() {
    local layer_name=$1
    local layer_path=$2
    bitbake-layers show-layers | grep "$layer_name" > /dev/null
	layer_info=$?
    if [ $layer_info -ne 0 ]; then
        echo "Adding $layer_name layer"
        bitbake-layers add-layer "$layer_path"
    else
        echo "$layer_name layer already exists"
    fi
}

check_and_add_layer "meta-aesd" "../meta-aesd"
check_and_add_layer "meta-raspberrypi" "../meta-raspberrypi"
check_and_add_layer "meta-oe" "../meta-openembedded/meta-oe"
check_and_add_layer "meta-python" "../meta-openembedded/meta-python"
check_and_add_layer "meta-networking" "../meta-openembedded/meta-networking"

set -e
bitbake core-image-aesd
