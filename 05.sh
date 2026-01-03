#!/usr/bin/env bash

set -e # Exit on error

echo "in 05.sh"
echo "Purpose: workflows"

guix install screen conda gwl btop python R

conda init
