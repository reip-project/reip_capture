#!/bin/bash

echo "	--- Creating Linux services ---"

sudo cp /home/reip/reip_capture/reip_capture.service /etc/systemd/system/reip_capture.service

sudo systemctl enable reip_capture.service