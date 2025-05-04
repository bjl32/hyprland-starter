#!/bin/bash
echo ":: Creating temporary folder..."
mkdir ~/tmp
cd ~/tmp
echo ":: Downloading gum 0.16.0..."
wget https://github.com/charmbracelet/gum/releases/download/v0.16.0/gum_0.16.0_Linux_x86_64.tar.gz
echo ":: Installing gum 0.16.0..."
as_root cp gum_0.16.0_Linux_x86_64/gum /usr/bin/
echo ":: Cleaning gum 0.16.0 Up..."
rm -r gum*
echo ":: gum 0.16.0 is installed!"
echo "All requirements satisfied!"