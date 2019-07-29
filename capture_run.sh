#!/bin/bash

echo "*** Capture run ***"

local_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

setup_dir=$local_dir/setup
task_dir=$local_dir/capture
local_data_dir="/mnt/reip_data"

sudo chmod -R +x .

/bin/bash $setup_dir/camera_setup.sh "$local_dir"

/bin/bash $setup_dir/partition_setup.sh "$local_data_dir"
/bin/bash $setup_dir/nas_setup.sh "$local_dir"

/bin/bash $task_dir/capture_mode.sh "$local_dir"