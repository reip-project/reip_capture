#!/bin/bash

echo "*** Capture run ***"

local_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

setup_dir=$local_dir/setup
task_dir=$local_dir/capture
local_data_dir="/mnt/reip_data"

find $local_dir -name "*.sh" -exec chmod +x {} +
chown -R reip $local_dir

/bin/bash $setup_dir/service_setup.sh

/bin/bash $setup_dir/camera_setup.sh "$local_dir"

/bin/bash $setup_dir/partition_setup.sh "$local_data_dir"
/bin/bash $setup_dir/nas_setup.sh "$local_dir"

pkill -f "backup_data.sh"
/bin/bash $task_dir/backup_data.sh "$local_data_dir" "$local_dir" &

/bin/bash $task_dir/capture_mode.sh "$local_dir"

