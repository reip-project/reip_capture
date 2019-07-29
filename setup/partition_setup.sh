#!/bin/bash

echo "	--- Creating data partition on first boot ---"

# TODO: change below code to create partition 
data_dir=$1

if ! test -d "$data_dir"; then
	sudo mkdir "$data_dir"
fi

if ! test -d "$data_dir/port_0"; then
	sudo mkdir "$data_dir/port_0"
fi

if ! test -d "$data_dir/port_1"; then
	sudo mkdir "$data_dir/port_1"
fi

sudo chown -R reip "$data_dir"