#!/bin/bash

echo "create overlay"
rm -f ol.img
# 1024:1G 10240:10G
apptainer overlay create --fakeroot --size 10240 ol.img

echo "run installer I for overlay"
cat install-to-overlay_I.sh | apptainer exec \
	--fakeroot --containall --no-home --no-mount bind-paths \
	--bind /dev \
	--overlay ol.img os.sif bash 

#echo "run installer II"
#apptainer exec --fakeroot --overlay ol.img os.sif bash ./install-to-overlay_II.sh

#echo "create sif from overlay"
#apptainer build uncommon-machine.sif "${sandbox}"


