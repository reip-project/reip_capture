#!/bin/bash

echo "	--- Creating Linux services and installing lsof using apt ---"

apt install lsof

cp /home/reip/reip_capture/reip_capture.service /etc/systemd/system/reip_capture.service

systemctl enable reip_capture.service
