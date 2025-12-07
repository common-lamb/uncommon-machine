#!/bin/bash

# check fakeroot allowed
rootp=$(apptainer exec --fakeroot docker://alpine whoami)
if [ "${rootp}" == "root" ]; then
	echo "You have root in apptainer"

else
	echo "FATAL: Root required in apptainer"
	echo "In the image(attempt), whoami returns: ${rootp}"
	exit 1
fi

