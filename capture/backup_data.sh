#!/bin/bash

echo "	--- Copying files to backup location ---"

mac_address=$(cat /sys/class/net/eth0/address | sed s/://g | tr "[:upper:]" "[:lower:]")

local_data_dir=$1
local_dir=$2
nfs_path="$local_dir/nfs"
node_nfs_outpath=$nfs_path/$mac_address

while true
do
	for f in $(find $local_data_dir -type f)
	do
		if [ -z $(fuser $f) ]
		then
			mv $f $node_nfs_outpath
		fi
	done
	sleep 1
done