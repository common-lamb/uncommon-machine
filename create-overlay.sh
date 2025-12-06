#!/bin/bash



 user=$(whoami)
 mkdir -p /tmp/${user}
 TMPDIR=/tmp/${user}

 
 echo "create sandbox in ${TMPDIR}"
 # &&& remove sandbox but need recursive permissions opened first
 chmod -R u+rwX /tmp/${user}/uncommon-machine
 apptainer build --force --fakeroot --sandbox /tmp/${user}/uncommon-machine docker://alpine
 yes | apptainer cache clean

 # create and run shell with overlay
 echo "delete overlay"
 rm -f uncommon-overlay.img
 echo "create overlay"
  # 10 Gibyte
 apptainer overlay create --fakeroot --size 10240 uncommon-overlay.img

 # works, bash installed, guix on hold
 echo "run installer I for overlay"
 apptainer exec --fakeroot --overlay uncommon-overlay.img \
	 /tmp/${user}/uncommon-machine \
	 sh ./install-to-overlay_I.sh
         # sh in alpine just this once

 echo "run installer II for overlay"
 apptainer exec --fakeroot --overlay uncommon-overlay.img \
	 /tmp/${user}/uncommon-machine \
	 bash ./install-to-overlay_II.sh

 #creat sif from sandbox
 apptainer build uncommon-machine.sif /tmp/${user}/uncommon-machine


