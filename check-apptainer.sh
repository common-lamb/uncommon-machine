#!/bin/bash

# check fakeroot allowed
is_root=$(apptainer exec --fakeroot docker://ubuntu whoami)
if [ "${is_root}" == "root" ]; then
	echo "you have root in apptainer"

else
	echo "root required in apptainer"
	exit 1
fi

