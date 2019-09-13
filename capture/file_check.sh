#!/bin/bash

echo "	--- Checking for disk usage ---"

# If disk usage hits 95%, calculate how many files are needed to delete to bring down to 90%
# In steps:
# 1. Get file size of 2 files to represent an instance in time - same time stamp, different port
# 2. Calculate how many of these represent 5% of disk space
# 3. Delete this number of pairs that have the same timestamp, spread evenly across the file list

local_data_dir=$1
# local_data_dir="/mnt/reip_data"

del_limit=$2

while true; do
	sleep 5
	cur_hd_util=$(df --output=pcent / | tr -dc '0-9')

	if [ $cur_hd_util -lt $del_limit ]; then
		echo "Disk usage: $cur_hd_util"
		continue
	else
		file_list=(`find $local_data_dir -type f -name '*.mp4' -printf '%T@ %p\0' | sort -zk 1nr | sed -z 's/^[^ ]* //' | tr '\0' '\n'`)
		file_size=$(stat --printf="%s" "${file_list[1]}")
		disk_size=$(lsblk -b --output SIZE -n -d /dev/mmcblk0)
		drop_size=$(( $disk_size / 20 ))
		double_filesize=$(( $file_size * 2 ))
		num_to_drop=$(( $drop_size / $double_filesize ))
		file_list_len=${#file_list[@]}
		increment=$(( $file_list_len / $num_to_drop ))

		del_idx=($(seq 0 $increment $(( $file_list_len - 1 ))))

		for i in "${del_idx[@]}"; do
			file_to_del=${file_list[$i]}
			timestamp=$(echo $file_to_del | awk -F'[_.]' '{print $5}')
			find $local_data_dir -name "*$timestamp*" -type f -delete
			# find $local_data_dir -name "*$timestamp*" -type f
		done
	fi
done





