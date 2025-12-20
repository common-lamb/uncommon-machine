#!/bin/bash

apptainer pull --disable-cache --force os.sif docker://jas4711/debian-with-guix:stable
# yes | apptainer cache clean
