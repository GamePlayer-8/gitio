#!/bin/sh

cd /

curl -LO "https://gameplayer-8.codeberg.page/gitio/packages/zst/pkg.tar.gz"

tar -xvf pkg.tar.gz
cp -r default-fs/* /
rm -rf default-fs
rm -f pkg.tar.gz
chmod +x /usr/bin/gitio
