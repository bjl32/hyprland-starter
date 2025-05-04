#!/bin/bash

# ----------------------------------------------------- 
# Functions for Setup
# ----------------------------------------------------- 

distro=""
installer=""

# Detect Linux Distribution
_detectDistro() {
    if [ -f /etc/fedora-release ] ;then
        distro="fedora"
        installer="fedora"
        echo ":: Installer for Fedora"
    fi
    if [ -f /etc/nobara-release ] ;then
        distro="nobara"
        installer="fedora"
        echo ":: Installer for Nobara"
    fi
    if [ -f /etc/arch-release ] ;then
        distro="arch"
        installer="arch"
        echo ":: Installer for Arch"
    fi
    if [ -f /etc/lfs-release ] ;then
        distro="lfs"
        installer="lfs"
        echo ":: Installer for LFS"
    fi
}

# Check if package is installed
_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# Install required packages
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}


# Check if package is installed
_isInstalledFedora() {
    package="$1";
    check=$(yum list installed | grep $package)
    if [ -z "$check" ]; then
        echo 1; #'1' means 'false' in Bash
        return; #false
    else
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi
}

# Install required packages
_installPackagesFedora() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledFedora "${pkg}") == 0 ]]; then
            echo "${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;
    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;
    printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo dnf install --assumeyes "${toInstall[@]}"
}

# Install required packages
_installPackagesLFS(){
    if [ -x /usr/bin/git ]; then # "Which" is somehow a BLFS package, so it cannot be used to detect git.
        echo "Git is installed at /usr/bin/git";
        return;
    else
        echo "Error: Git not found in /usr/bin/git. Git must be installed before using this script.(Do NOT forget to build git with curl)";
        exit 130;
    fi;

    if [ -x /usr/bin/wget ]; then
        echo "wget is installed at /usr/bin/wget";
        return;
    else
        echo "Error: wget not found in /usr/bin/wget. Wget must be installed before using this script.";
        exit 130;
    fi;

    if [ -x /usr/bin/bsdunzip ]; then
        echo "libarchive is installed at /usr/bin";
        return;
    else
        echo "Error: libarchive not found in /usr/bin/. libarchive must be installed before using this script.";
        exit 130;
    fi;

    if [ -x /usr/bin/rsync ]; then
        echo "rsync is installed at /usr/bin/rsync";
        return;
    else
        echo "Error: rsync not found in /usr/bin/rsync. Rsync must be installed before using this script.";
        exit 130;
    fi;

    mkdir ~/tmp/
    echo ":: Created temporary folder"
    cd ~/tmp/
    git clone https://github.com/bjl32/figlet-lfs.git
    echo ":: Obtained figlet source"
    cd figlet-lfs
    make -j$(nproc)
    echo ":: Compiled figlet."
    make install
    echo ":: Installed figlet."
    cd ~
    rm -r ~/tmp
    echo ":: Cleaned up."
}

# ----------------------------------------------------- 
# Packages
# ----------------------------------------------------- 

# Required packages for the installer on Arch
installer_packages_arch=(
    "figlet"
    "git"
)

# Required packages for the installer on Fedora
installer_packages_fedora=(
    "figlet"
    "git"
)

clear

# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'

# Header
echo -e "${GREEN}"
cat <<"EOF"
 ____       _               
/ ___|  ___| |_ _   _ _ __  
\___ \ / _ \ __| | | | '_ \ 
 ___) |  __/ |_| |_| | |_) |
|____/ \___|\__|\__,_| .__/ 
                     |_|    

EOF
echo "for ML4W Hyprland Starter"
echo
echo -e "${NONE}"

echo "This script will download the ML4W Hyprland Starter and start the installation."
echo
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
            echo
        break;;
        [Nn]* ) 
            echo "Installation canceled."
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ----------------------------------------------------- 
# Detect Distribution (Rewritten)
# ----------------------------------------------------- 
_detectDistro() {
    if [ -z "$distro" ]; then
        echo "ERROR: Your Linux distribution could not be detected or is not supported."
        echo
        echo "Please select one of the following installation profiles or cancel the installation."
        echo
        PS3="Enter your choice (1-4): "
        select version in "arch" "fedora" "lfs" "cancel"; do
            if [ -n "$version" ]; then
                break
            else
                echo "Invalid option. Please try again."
            fi
        done

        case "$version" in
            "arch")
                echo ":: Installer for Arch"
                distro="arch"
                installer="arch"
                ;;
            "fedora")
                echo ":: Installer for Fedora"
                distro="fedora"
                installer="fedora"
                ;;
            "lfs")
                echo ":: Installer for LFS"
                distro="LFS"
                installer="LFS"
                ;;
            "cancel"|*)
                echo ":: Setup canceled"
                exit 130
                ;;
        esac
    fi
}


# ----------------------------------------------------- 
# Installation for Fedora
# ----------------------------------------------------- 
if [ "$installer" == "fedora" ] ;then
    _installPackagesFedora "${installer_packages_fedora[@]}";
fi

# ----------------------------------------------------- 
# Installation for Arch
# ----------------------------------------------------- 
if [ "$installer" == "arch" ] ;then
    _installPackagesPacman "${installer_packages_arch[@]}";
fi

# ----------------------------------------------------- 
# Installation for LFS
# ----------------------------------------------------- 
if [ "$installer" == "lfs" ] ;then
    _installPackagesLFS
fi

# Create Downloads folder if not exists
if [ ! -d ~/Downloads ] ;then
    mkdir ~/Downloads
    echo ":: Downloads folder created"
fi

# Change into Downloads directory
cd ~/Downloads

# Remove existing folder
if [ -d ~/Downloads/hyprland-starter ] ;then
    rm -rf ~/Downloads/hyprland-starter
    echo ":: Existing installation folder removed"
fi

# Clone the packages
git clone --depth 1 https://github.com/mylinuxforwork/hyprland-starter.git
echo ":: Installation files cloned into Downloads folder"

# Change into the folder
cd hyprland-starter

# Start the script
./install.sh
