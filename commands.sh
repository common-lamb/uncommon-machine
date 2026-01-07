#!/usr/bin/env bash

# source this file

#### local image creation ####

# prerequisites guix install passt crun podman apptainer 

# build stage NN and any needed or modified precursors
um-build() {
    # usage: um-build 01
    #arg: NN the stage to build to eg. 00 01 02 ...
    [ -z "$1" ] && echo "must supply an NN integer arg" && return 1
    local NN=$1

    # podman  build --target stageNN --tag stage:NN .
    # --runtime $(which crun) # to find guix crun
    # --cap-add=SYS_ADMIN
    # --cap-add=NET_ADMIN
    # --security-opt seccomp=unconfined

    podman --runtime $(which crun) build \
           --security-opt seccomp=unconfined \
           --cap-add=SYS_ADMIN \
           --cap-add=NET_ADMIN \
           --target stage${NN}\
           --tag stage:${NN} \
           .
}

# local run tagged stage:NN
um-shell() {
    #arg: NN the stage to run eg. 00 01 02 ...
    [ -z "$1" ] && echo "must supply an NN integer arg" && return 1
    local NN=$1

    podman --runtime $(which crun) run --rm -it stage:${NN} /bin/bash
    # run --privileged
}

# tag and push to docker hub
um-push() {
    # usage: um-push 01
    #arg: NN the stage to push eg. 00 01 02 ...
    [ -z "$1" ] && echo "must supply an NN integer arg" && return 1
    local NN=$1

    podman tag stage:${NN} docker.io/commonlamb/uncommonmachine:latest
    echo "docker hub password required"
    podman login --username commonlamb docker.io
    podman push --retry 42 docker.io/commonlamb/uncommonmachine:latest
}

#### remote runs with apptainer ####

# get container as image
um-pull() {
	apptainer pull --disable-cache uncommon-machine.sif docker://commonlamb/uncommonmachine:latest
}

# create overlay and run container 
um-run() {

# ensure overlay
if [ ! -f ./overlay.img ]; then
	echo "no overlay, creating"
	# 1024 1G
	apptainer overlay create --fakeroot --size $((1024 * 4)) overlay.img
fi

# ensure sif 
[ ! -f ./uncommon-machine.sif ] && echo "use um-pull to pull uncommon-machine.sif" && return 1

echo "source .bashrc # after start"

# get going
apptainer shell \
	--fakeroot --containall --no-home --no-mount bind-paths \
	--overlay overlay.img uncommon-machine.sif

# optional binds
	#--bind ${HOME}/quick_access:/mounts/quick_access \
	
# optional bind /dev to ensure /dev/full exists during guix installs
	#--bind /dev:/dev \
	#
# one liner
# with-slurm apptainer shell --fakeroot --containall --no-home --no-mount bind-paths --bind ${HOME}:/mounts/meta-home --bind ${HOME}/quick_access:/mounts/quick_access --bind /dev:/dev --overlay overlay.img uncommon-machine.sif
	
}


