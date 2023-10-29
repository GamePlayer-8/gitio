#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

cp -rv "$SCRIPT_PATH"/packages/default-fs/* /

chmod +x /usr/bin/gitio
