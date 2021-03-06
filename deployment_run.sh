#!/bin/bash

echo "*** Deployment run ***"

local_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

setup_dir=$local_dir/setup
task_dir=$local_dir/deployment

chmod -R +x $local_dir

source "$setup_dir/camera_setup.sh"
source "$setup_dir/partion_setup.sh"
source "$setup_dir/nas_setup.sh"

source "$task_dir/deployment_mode.sh"
