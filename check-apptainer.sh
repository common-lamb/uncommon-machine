#!/bin/bash
# check fakeroot allowed
apptainer exec --fakeroot docker://ubuntu whoami #=> root
