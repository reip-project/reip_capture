#!/bin/bash

echo "--- Creating NFS mount location and mounting ---"

local_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
nfs_path="$local_dir/nfs"

# Create NFS location if it doesnt exist
if ! test -d "$nfs_path"; then
	mkdir "$nfs_path"
fi

# https://www.seagate.com/support/kb/how-to-mount-nfs-and-cifs-file-systems-on-linux-with-the-seagate-blackarmor-nas-209791en/

# Create NFS mount
nas_ip='192.168.1.1'
nas_ext_path_root="/reip-data" # Unsure about full path of remote location - TODO

sudo mount -t nfs "$nas_ip:/$nas_ext_path_root $nfs_path"

echo "--- Checking if NFS location is successfully mounted ---"

# https://stackoverflow.com/questions/9159839/bash-checking-directory-existence-hanging-when-nfs-mount-goes-down
# https://unix.stackexchange.com/questions/72223/check-if-folder-is-a-mounted-remote-filesystem

echo "--- Checking if NFS location is writeable ---"

if ! [ -w "$nfs_path" ]; then
	echo "ERROR: NSF location is not writeable"
	echo "Exiting"
fi

exit 0