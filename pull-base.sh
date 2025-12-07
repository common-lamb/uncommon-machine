#!/bin/bash

rm -f os.sif
apptainer pull os.sif docker://jas4711/debian-with-guix:stable
# &&& --diasble cache?
yes | apptainer cache clean
