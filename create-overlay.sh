#!/bin/bash

  # create and run shell with overlay
  echo "del ol"
  rm -f uncommon-overlay.img
  echo "create ol"
  # 10 Gibyte
  apptainer overlay create --fakeroot --size 10240 uncommon-overlay.img
  echo "run installer for ol"
  apptainer exec --fakeroot --contain --overlay uncommon-overlay.img os.sif bash install-to-overlay.sh
