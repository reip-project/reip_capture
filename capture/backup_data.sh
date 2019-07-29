#!/bin/bash

echo "	--- Copying files to backup location ---"

local_dir=$1
nfs_path="$local_dir/nfs"
node_nfs_outpath=$nfs_path/$mac_address

while true
do
	for f in $(find $local_dir -type f)
	do
		mv $f $node_nfs_outpath
	done
	sleep 1
done