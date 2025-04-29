distro=""
installer=""

# Check for distro
if [ -z "$1" ] ;then
    if [ -f /etc/fedora-release ] ;then
        distro="fedora"
        installer="fedora"
    fi
    if [ -f /etc/arch-release ] ;then
        distro="arch"
        installer="arch"
    fi
    if [ -f /etc/nobara-release ] ;then
        distro="nobara"
        installer="fedora"
    fi
    if [ -f /etc/lfs-release ] ;then
        distro="lfs"
        installer="lfs"
    fi
else
    if [[ "$1" == "nobara" ]]; then
        distro="nobara"
        installer="fedora"
    fi
    if [[ "$1" == "fedora" ]]; then
        distro="fedora"
        installer="fedora"
    fi
    if [[ "$1" == "arch" ]]; then
        distro="arch"
        installer="arch"
    fi
    if [[ "$1" == "lfs" ]] ;then
        distro="lfs"
        installer="lfs"
    fi
fi



# ----------------------------------------------------- 
# Detect Distribution (Rewritten)
# ----------------------------------------------------- 
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


echo "$distro" > dotfiles/.config/ml4w/settings/distro
