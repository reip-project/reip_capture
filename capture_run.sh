
#!/bin/bash

echo "*** Capture run ***"

local_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

setup_dir=$local_dir/setup
task_dir=$local_dir/capture
local_data_dir="/mnt/reip_data"

# Add nightly shutdown cronjob
crontab -l | grep -q 'nightly_reboot'  && echo 'entry exists' || cat <(crontab -l) <(echo '0 2 * * * $local_dir/setup/nightly_reboot.sh') | crontab -

find $local_dir -name "*.sh" -exec chmod +x {} +
chown -R reip $local_dir

/bin/bash $setup_dir/service_setup.sh

/bin/bash $setup_dir/camera_setup.sh "$local_dir"

/bin/bash $setup_dir/partition_setup.sh "$local_data_dir"
/bin/bash $setup_dir/nas_setup.sh "$local_dir" "192.168.0.108"

pkill -f "backup_data.sh"
/bin/bash $task_dir/backup_data.sh "$local_data_dir" "$local_dir" "192.168.0.108" &

pkill -f "file_check.sh"
/bin/bash $task_dir/file_check.sh "$local_data_dir" 95 &

/bin/bash $task_dir/capture_mode.sh "$local_dir"
