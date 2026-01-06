#!/usr/bin/env bash

## source this file
## prerequisites guix install passt crun podman apptainer


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
    podman push docker.io/commonlamb/uncommonmachine:latest
}

# &&& remote run

# um-pull
#apptainer pull docker://commonlamb/uncommonmachine:latest

# um-run
#apptainer run --no-home --fakeroot &&&
