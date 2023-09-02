#!/bin/sh

INSTALLER="${INSTALLER:-'apt install -y curl tar gzip'}"

cd /

if [ -z "$NOINSTALL" ]; then
    exec $INSTALLER
fi

curl -LO "https://gameplayer-8.codeberg.page/gitio/packages/zst/pkg.tar.gz"

tar -xvf pkg.tar.gz
rm -f pkg.tar.gz
chmod +x /usr/bin/gitio
