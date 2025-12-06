#!/bin/bash

rm -f os.sif
#apptainer pull os.sif docker://ubuntu
apptainer pull os.sif docker://alpine
# &&& consider switch to alpine
yes | apptainer cache clean
