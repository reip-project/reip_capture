	#!/bin/bash

echo "	--- Creating NFS mount location and mounting ---"

local_dir=$1
nfs_path="$local_dir/nfs"
nas_ip=$2

# Create NFS location if it doesnt exist
if ! test -d "$nfs_path"; then
	mkdir "$nfs_path"
	chown -R root "$nfs_path"
fi

# https://www.seagate.com/support/kb/how-to-mount-nfs-and-cifs-file-systems-on-linux-with-the-seagate-blackarmor-nas-209791en/

# Create NFS mount
# nas_ip='192.168.0.108'

nas_ext_path_root="/volume1/reip_data_nas" # Unsure about full path of remote location - TODO

mount -t nfs $nas_ip:$nas_ext_path_root $nfs_path

# echo "	--- Checking if NFS location is successfully mounted ---"

# https://stackoverflow.com/questions/9159839/bash-checking-directory-existence-hanging-when-nfs-mount-goes-down
# https://unix.stackexchange.com/questions/72223/check-if-folder-is-a-mounted-remote-filesystem

echo "	--- Checking if NFS location is writeable ---"

if ! [ -w "$nfs_path" ]; then
	echo "		ERROR: NSF location is not writeable"
	echo "		Exiting"
	echo 1
else
	echo "		NFS path is writeable"
	echo
fi

echo "	--- Create node data out folder on NAS ---"

mac_address=$(cat /sys/class/net/eth0/address | sed s/://g | tr "[:upper:]" "[:lower:]")

node_nfs_outpath=$nfs_path/$mac_address

if ! test -d "$node_nfs_outpath"; then
	mkdir "$node_nfs_outpath"
	chown -R root "$node_nfs_outpath"
fi
