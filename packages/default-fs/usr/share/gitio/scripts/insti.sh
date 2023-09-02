#!/bin/sh

INSTALL="${@:-INSTALL}"
INSTALL="${INSTALL:-''}"
os="$(uname -s)"
package_naming="apt:openssh:openssh-server apt:go:golang apt:docker:docker.io"

xapt() {
    DEBIAN_FRONTEND=noninteractive
    TZ=UTC
    apt update
    apt install --yes $*
}

xapk() {
    apk add --no-cache $*
}

xpacman() {
    pacman -Syu --noconfirm --overwrite=* $*
}

xdnf() {
    dnf install -y $*
}

xopium() {
    echo "Your Linux is wild and opium isn't implemented yet, exiting..."
    exit 2
}

xdarwin() {
    echo "Running on macOS!"
    echo "EEPY ROM, goodbye uwu"
    exit 69
}

xunknown() {
    echo 'Unknown kernel.'
    exit 1
}

get_installer() {
    case "$1" in
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
                distro="XaviaMa"
            fi

            case "$distro" in
                    "Debian")
                        echo 'apt'
                        ;;
                    "Ubuntu")
                        echo 'apt'
                        ;;
                    "Fedora")
                        echo 'dnf'
                        ;;
                    "Alpine")
                        echo 'apk'
                        ;;
                    "Arch")
                        echo 'pacman'
                        ;;
                    "Artix")
                        echo 'pacman'
                        ;;
                    "XaviaMa")
                        echo 'opium'
                        ;;
                    *)
                        echo 'opium'
                        ;;
            esac

            ;;
        Darwin*)
            echo 'darwin'
            ;;
        *)
            echo 'unknown'
            ;;
    esac
}

installer="$(get_installer "$os")"

updated_list=""

while IFS=' ' read -r parts; do
    IFS=':' read -r installer_type orig_pkg pkg <<EOF
$parts
EOF
    while IFS=' ' read -r xpackage; do
        if [ "$installer" = "$installer_type" ]; then
            
                if [ "$xpackage" = "$orig_pkg" ]; then
                    updated_list="${updated_list}${pkg} "
                else
                    updated_list="${updated_list}${xpackage} "
                fi
            
        else
            updated_list="${updated_list}${xpackage} "
        fi
    done <<EOF
$INSTALL
EOF
done <<EOF
$package_naming
EOF

eval "x${installer} \"${updated_list}\""

