# REIP capture scripts

Login as root: `sudo -s`

Install `lsof`: `apt install lsof`

Clone repository to the `/home/reip` directory and run `/bin/bash /home/reip/reip_capture/capture_run.sh`

This will begin recording after ensuring everything is setup correctly. It will also create the systemctl service so that the scripts will run at boot. See comments in script files for more detailed information.
