#!/bin/bash

echo "	--- Copying files to backup location ---"

mac_address=$(cat /sys/class/net/eth0/address | sed s/://g | tr "[:upper:]" "[:lower:]")

local_data_dir=$1
local_dir=$2
nfs_path="$local_dir/nfs"
node_nfs_outpath=$nfs_path/$mac_address

# Create NFS mount
# nas_ip='192.168.0.108'
nas_ip=$(arp -a | grep "reip_nas_B0D4" | awk -F ' ' '{print $2}' | tr -d '()')
nas_ext_path_root="/volume1/reip_data_nas" # Unsure about full path of remote location - TODO

while true
do
	if ! [ "$(stat -f -L -c %T $nfs_path)" = "nfs" ]
	then
		mount -t nfs $nas_ip:$nas_ext_path_root $nfs_path
		sleep 5
		continue
	fi

	for f in $(find $local_data_dir -type f)
	do
		if [ -z $(fuser $f) ]
		then
			mv $f $node_nfs_outpath
		fi
	done
	sleep 1
done
