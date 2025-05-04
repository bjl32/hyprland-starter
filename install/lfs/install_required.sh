mkdir ~/tmp
cd ~/tmp
wget https://github.com/charmbracelet/gum/releases/download/v0.16.0/gum_0.16.0_Linux_x86_64.tar.gz
as_root cp gum_0.16.0_Linux_x86_64/gum /usr/bin/
rm -r gum*
