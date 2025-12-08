#!/bin/bash

echo "create overlay"
rm -f ol.img
# 1024:1G 10240:10G
apptainer overlay create --fakeroot --size 1024 ol.img
# &&& add to os.sif?

echo "run installer I for overlay"
#apptainer exec  --fakeroot --overlay ol.img os.sif bash ./install-to-overlay_i.sh
cat install-to-overlay_I.sh | apptainer exec --fakeroot --containall --no-home --overlay ol.img os.sif bash 

# --contain --bind $(pwd)

#echo "run installer II"
#apptainer exec --fakeroot --overlay ol.img os.sif bash ./install-to-overlay_II.sh

#echo "create sif from overlay"
#apptainer build uncommon-machine.sif "${sandbox}"


