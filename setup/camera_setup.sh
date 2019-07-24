#!/bin/bash

# Get current working directory
local_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
tmp_path="$local_dir/tmp"
# Create temp folder if it doesnt exist already
if ! test -d "$tmp_path"; then
	mkdir "$tmp_path"
fi

# Mount RAM disk partition at temp path local location
sudo mount -t tmpfs -o size=2G,mode=0755 tmpfs "$tmp_path"
sudo chown -R reip "$tmp_path"


echo "--- Checking if both cameras are connected ---"

# port_0 is bottom left USB port as you look at the mounted Jetson inside the housing
# usually used for the right facing camera
port_0="/dev/v4l/by-path/platform-70090000.xusb-usb-0:2.3:1.0-video-index0"

# port_1 is bottom right USB port as you look at the mounted Jetson inside the housing
# usually used for the left facing camera
port_1="/dev/v4l/by-path/platform-70090000.xusb-usb-0:2.1:1.0-video-index0"

if test -e "$port_0"; then
    echo "Camera found at port_0"
else
	echo "ERROR: camera missing at port_0"
	echo "    (plug USB camera into the bottom left USB port)"
	echo "Exiting"
	exit 1
fi

if test -e "$port_1"; then
    echo "Camera found at port_1"
else
	echo "ERROR: camera missing at port_1"
	echo "    (plug USB camera into the bottom right USB port)"
	echo
	echo "Exiting"
	exit 1
fi
echo
echo "--- Capturing simulataneous test video from each camera ---"

# Set video parameters
width=2592
height=1944
framerate=15
numbuffers=90
bitrate=20000000

# Set output paths
port_0_out="$tmp_path/port_0.mp4"
port_1_out="$tmp_path/port_1.mp4"

# Launch test capture on camera 0 (non blocking)
gst-launch-1.0 v4l2src num-buffers="$numbuffers" device="$port_0" \
	! image/jpeg,width="$width",height="$height",framerate="$framerate"/1 \
	! jpegdec \
	! nvvidconv \
	! 'video/x-raw(memory:NVMM), format=(string)I420' \
	! omxh265enc bitrate="$bitrate" \
	! 'video/x-h265, stream-format=(string)byte-stream' \
	! h265parse \
	! qtmux \
	! filesink location="$port_0_out" \
	> /dev/null 2>&1 \
	&

# Launch test capture on camera 1 (blocking)
gst-launch-1.0 v4l2src num-buffers="$numbuffers" device="$port_1" \
	! image/jpeg,width="$width",height="$height",framerate="$framerate"/1 \
	! jpegdec \
	! nvvidconv \
	! 'video/x-raw(memory:NVMM), format=(string)I420' \
	! omxh265enc bitrate="$bitrate" \
	! 'video/x-h265, stream-format=(string)byte-stream' \
	! h265parse \
	! qtmux \
	! filesink location="$port_1_out" \
	> /dev/null 2>&1

# Check if camera 0 recorded video with reasonable size
if [[ $(find "$port_0_out" -type f -size +1024000c 2>/dev/null) ]]; then
	echo "$port_0_out written to RAM disk"
	# gst-discoverer-1.0 $port_0_out
else
    echo "ERROR: output file $port_0_out missing or too small in size"
    echo "    (check gst-launch settings)"
	echo
	echo "Exiting"
	exit 1
fi

# Check if camera 0 recorded video with reasonable size
if [[ $(find "$port_1_out" -type f -size +1024000c 2>/dev/null) ]]; then
	echo "$port_1_out written to RAM disk"
	# gst-discoverer-1.0 $port_0_out
else
    echo "ERROR: output file $port_1_out missing or too small in size"
    echo "    (check gst-launch settings)"
	echo
	echo "Exiting"
	exit 1
fi

# Remove test files
rm $port_0_out
rm $port_1_out

echo
echo "--- Camera setup and tests successful ---"

exit 0