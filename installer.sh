#!/bin/sh

os="$(uname -s)"

apt() {
    export DEBIAN_FRONTEND=noninteractive
    export TZ=Europe/Warsaw
    apt update
    apt install --yes git podman coreutils fuse-overlayfs gawk tar gzip wget curl bash openssh
}

apk() {
    apk add --no-cache bash podman fuse-overlayfs gawk tar gzip wget curl git coreutils openssh
}

pacman() {
    pacman -Syu --noconfirm --overwrite=* git podman coreutils fuse-overlayfs gawk tar gzip wget curl bash openssh
}

dnf() {
    dnf install -y git podman coreutils fuse-overlayfs gawk tar gzip wget curl bash openssh
}

opium() {
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
            opium
        fi

        case "$distro" in
            Debian)
                apt
                ;;
            Ubuntu)
                apt
                ;;
            Fedora)
                dnf
                ;;
            Alpine)
                apk
                ;;
            Arch)
                pacman
                ;;
            Artix)
                pacman
                ;;
            *)
                opium
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
