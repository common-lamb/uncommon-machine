#!/bin/bash

# create location for sandbox
## local
here=$(realpath $(pwd))
mach="${here}/machine"
sandbox="${mach}"
mkdir -p "${sandbox}"

# pick location for temp
#user=$(whoami)
## one of
#temp="${here}/temp" # fails if network drive
#temp="/tmp/${user}/machine" # fails on &&&
#temp="/var/tmp/${user}/machine" # fails on &&&
#temp="/gpfs/fs7/aafc/scratch/sth003/machine" #fails on &&&
#temp="/fs/vnas_Haafc/agr/sth003/machine"

# set temp dir env variable. Cannot be a network drive&&&
#TMPDIR="${temp}"
#mkdir -p "${TMPDIR}" 

echo "create overlay"
rm -f ol.img
# 1024:1G 10240:10G
apptainer overlay create --fakeroot --size 10240 ol.img
# &&& add to os.sif?

echo "run installer I for overlay"
apptainer exec  --fakeroot --overlay ol.img os.sif bash ./install-to-overlay_I.sh
# --contain --bind $(pwd)

#echo "run installer II"
#apptainer exec --fakeroot --overlay ol.img os.sif bash ./install-to-overlay_II.sh

#echo "create sif from overlay"
#apptainer build uncommon-machine.sif "${sandbox}"


