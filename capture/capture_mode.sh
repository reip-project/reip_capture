#!/bin/bash

echo "	--- Starting video capture ---"

local_dir=$1
tmp_path="$local_dir/tmp"

data_dir="/mnt/reip_data"

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

echo "	$width x $height, $framerate fps, $numbuffers buffers, $bitrate bps"

# Set output paths with eth0 mac address excluding path for timestamp appending with path
mac_address=$(cat /sys/class/net/eth0/address | sed s/://g | tr "[:upper:]" "[:lower:]")
port_0_out="$tmp_path/port_0_$mac_address_"
port_1_out="$tmp_path/port_1_$mac_address_"
extension=".mp4"


while true
do
	utc_ts=$(date +%s)
	port_0_outpath=$port_0_out$utc_ts$extension

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
		! filesink location="$port_0_outpath" \
		> /dev/null 2>&1 \
		&

	port_1_outpath=$port_1_out$utc_ts$extension

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
		! filesink location="$port_1_outpath" \
		> /dev/null 2>&1

	# Move files from RAM disk to data partition (non blocking)
	sudo mv "$port_0_outpath" "$data_dir/port_0/port_0_$mac_address_$utc_ts$extension" &
	sudo mv "$port_1_outpath" "$data_dir/port_1/port_1_$mac_address_$utc_ts$extension" &

done

