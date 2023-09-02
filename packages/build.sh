#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
INSTALLER="${SCRIPT_PATH}/default-fs/usr/share/gitio/scripts/insti.sh"

build_deb() {
    rm -rf "$SCRIPT_PATH"/deb
    mkdir "$SCRIPT_PATH"/deb
    cp -r "$SCRIPT_PATH"/default-fs "$SCRIPT_PATH"/deb/debian
    mkdir -p "$SCRIPT_PATH"/deb/debian/DEBIAN
    cp "$SCRIPT_PATH"/control "$SCRIPT_PATH"/deb/debian/DEBIAN/control
    chmod 0755 "$SCRIPT_PATH"/deb/debian/DEBIAN/*
    chmod 0644 "$SCRIPT_PATH"/deb/debian/DEBIAN/control
    sh "${INSTALLER}" dpkg
    cd "$SCRIPT_PATH"
    dpkg-deb --build deb/debian
    mv deb/debian.deb ./gitio.deb
    rm -rf deb
    sha256sum "$SCRIPT_PATH"/*.deb > "$SCRIPT_PATH"/debian.sha256.txt
}

build_zst() {
    sh "${INSTALLER}" tar gzip
    cd "$SCRIPT_PATH"
    tar -czvf pkg.tar.gz default-fs
    rm -rf "$SCRIPT_PATH"/zst
    mkdir "$SCRIPT_PATH"/zst
    mv pkg.tar.gz zst/
    sha256sum zst/pkg.tar.gz > zst.sha256.txt
}

build_apk() {
    sh "${INSTALLER}" alpine-sdk
    rm -rf "$SCRIPT_PATH"/apk
    mkdir -p "$SCRIPT_PATH"/apk/{src,pkg}
    cd "$SCRIPT_PATH"/apk/src
    cp "$SCRIPT_PATH"/APKBUILD .
    abuild -r
    cd "$SCRIPT_PATH"
    mv "$SCRIPT_PATH"/apk/pkg/* gitio.apk
    rm -rf apk
}

prepare() {
    chmod +x "$SCRIPT_PATH"/default-fs/usr/bin/*
}

prepare
build_deb
build_zst
build_apk
