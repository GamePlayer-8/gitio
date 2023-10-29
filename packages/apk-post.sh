#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

build_apk() {
    apk add --no-cache alpine-sdk sudo
    rm -rf "$SCRIPT_PATH"/apk
    mkdir -p "$SCRIPT_PATH"/apk/src
    mkdir "$SCRIPT_PATH"/apk/pkg
    cd "$SCRIPT_PATH"/apk/src
    cp "$SCRIPT_PATH"/APKBUILD .
    sh "$INSTALLER" sudo
    apk update
    adduser -D -G abuild abuild
    chown -R abuild "$SCRIPT_PATH"/apk
    sudo -u abuild abuild-keygen -a -n -q
    sudo -u abuild abuild checksum
    sudo -u abuild abuild -r -m
    cd "$SCRIPT_PATH"
    find / -name '*.apk' | xargs -I '{}' sh -c 'mv {} "$(basename {})"'  2>/dev/null 3>&2 1>&2
    rm -rf apk
    for item in ./*.apk; do
        chown -R root:root "$item"
    done
}

build_apk

