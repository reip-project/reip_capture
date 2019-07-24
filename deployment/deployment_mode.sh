#!/bin/bash

echo "--- Starting deployment mode ---"

local_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
tmp_path="$local_dir/tmp"

# port_0 is bottom left USB port as you look at the mounted Jetson inside the housing
# usually used for the right facing camera
port_0="/dev/v4l/by-path/platform-70090000.xusb-usb-0:2.3:1.0-video-index0"

# port_1 is bottom right USB port as you look at the mounted Jetson inside the housing
# usually used for the left facing camera
port_1="/dev/v4l/by-path/platform-70090000.xusb-usb-0:2.1:1.0-video-index0"

# Set video parameters
width=2592
height=1944
framerate=15
numbuffers=90
bitrate=20000000

# TODO: setup RT feed from admin laptop connected to switch to help with node orientation