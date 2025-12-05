#!/bin/bash

rm -f os.sif
apptainer pull os.sif docker://ubuntu
# &&& consider switch to alpine
yes | apptainer cache clean
