#!/bin/bash

#echo "create overlay"
#rm -f ol.img
# 1024:1G 10240:10G
#apptainer overlay create --fakeroot --size 10240 ol.img

#echo "run installer I: guix base"
#cat install-to-overlay_I.sh | apptainer exec \
	#--fakeroot --containall --no-home --no-mount bind-paths \
	#--bind /dev \
	#--overlay ol.img os.sif bash 
	
#echo "run installer II: guix secondary"
#cat install-to-overlay_II.sh | apptainer exec \
	#--fakeroot --containall --no-home --no-mount bind-paths \
	#--bind /dev \
	#--overlay ol.img os.sif bash 

#echo "run installer III: certs, keys, passwords"
#cat install-to-overlay_III.sh | apptainer exec \
	#--fakeroot --containall --no-home --no-mount bind-paths \
	#--bind /dev \
	#--overlay ol.img os.sif bash 
	
#echo "&&& run installer X: emacs, spacemacs, spacemacs support"
#echo "&&& run installer X: conda, gwl"

echo "run installer IIII: sbcl, ql, ul, shl, qlot "
cat install-to-overlay_IIII.sh | apptainer exec \
	--fakeroot --containall --no-home --no-mount bind-paths \
	--bind /dev \
	--overlay ol.img os.sif bash 

# salloc --time=04:04:04 --cluster=gpsc8 --cpus-per-task=8 --account=aafc_aac \
echo "run installer IIIII: kitty, lish, lem, nyxt, xpra, stumpwm"

#
#rclone magic-wormhole cloudflare n2n syncthing borg/matic nextcloud
#
#lunaria light palette
#
#useradd user password, copy root home, lish shell


#echo "create sif from overlay"
#apptainer build uncommon-machine.sif "${sandbox}"


