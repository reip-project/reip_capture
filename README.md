# REIP capture scripts

Login as root: `sudo -s`

Install `lsof`: `apt install lsof`

Clone repository to the `/home/reip` directory and run `/bin/bash /home/reip/reip_capture/capture_run.sh`

This will begin recording after ensuring everything is setup correctly. It will also create the systemctl service so that the scripts will run at boot. See comments in script files for more detailed information.

The IP address for the NAS needs to be manually added in two places in the `reip_capture/capture_run.sh` file:

```
line 12: /bin/bash $setup_dir/nas_setup.sh "$local_dir" "<NAS_IP_ADDESS>"
line 26: /bin/bash $task_dir/backup_data.sh "$local_data_dir" "$local_dir" "<NAS_IP_ADDESS>" &
```
