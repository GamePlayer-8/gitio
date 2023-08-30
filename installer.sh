#!/bin/sh

os="$(uname -s)"

xapt() {
    export DEBIAN_FRONTEND=noninteractive
    export TZ=Europe/Warsaw
    apt update
    apt install --yes git podman coreutils fuse-overlayfs gawk tar gzip wget curl openssh-server jq
}

xapk() {
    apk add --no-cache podman fuse-overlayfs gawk tar gzip wget curl git coreutils openssh jq
}

xpacman() {
    pacman -Syu --noconfirm --overwrite=* git podman coreutils fuse-overlayfs gawk tar gzip wget curl openssh jq
}

xdnf() {
    dnf install -y git podman coreutils fuse-overlayfs gawk tar gzip wget curl openssh jq
}

xopium() {
    echo "Your Linux is wild and opium isn't implemented yet, exiting..."
    exit 2
}

case "$os" in
    Linux*)
        # Check for specific Linux distributions
        if [ -f /etc/lsb-release ]; then
            . /etc/lsb-release
            distro=$DISTRIB_ID
        elif [ -f /etc/os-release ]; then
            . /etc/os-release
            distro=$ID
        elif [ -f /etc/debian_version ]; then
            distro="Debian"
        elif [ -f /etc/arch-release ]; then
            distro="Arch"
        else
            xopium
        fi

        case "$distro" in
                "Debian")
                    xapt
                    ;;
                "Ubuntu")
                    xapt
                    ;;
                "Fedora")
                    xdnf
                    ;;
                "Alpine")
                    xapk
                    ;;
                "Arch")
                    xpacman
                    ;;
                "Artix")
                    xpacman
                    ;;
                *)
                    xopium
                    ;;
        esac

        ;;
    Darwin*)
        echo "Running on macOS!"
        echo "EEPY ROM, goodbye uwu"
        exit 69
        ;;
    *)
        echo "Unknown operating system: $os"
        exit 1
        ;;
esac
