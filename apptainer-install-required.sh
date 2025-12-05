  # either you with root or admin must install apptainer
  # https://apptainer.org/docs/user/main/quick_start.html
  # such that fakeroot will work in the container
  # this is the single action requiring root on the real machine

  # for ubuntu
  sudo add-apt-repository -y ppa:apptainer/ppa
  sudo apt update
  sudo apt install -y apptainer
