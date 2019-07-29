#!/bin/bash

echo "*** Monitoring disk usage ***"

while true
do
	usage_percen=$(df -h / --output=pcent | tail -n 1 | sed 's/%//' | tr -d '[:space:]')
	if [ $usage_percen -gt 6 ]
	then
		echo "Fucccccck!!!!!!!"
	fi
	echo $usage_percen
	sleep 1
done
# ls -t /mnt/reip_data/