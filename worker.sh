#!/bin/sh

# A worker is for processing stuff defined by the repo.

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
INSTALLER="$SCRIPT_PATH"/packages/default-fs/usr/share/gitio/scripts/insti.sh

sh "$SCRIPT_PATH"/packages/build.sh
rm -rf "$SCRIPT_PATH"/.gitignore

sh "$INSTALLER" sed

export DOCS_PATH="$SCRIPT_PATH/docs"

sh "$SCRIPT_PATH"/index.sh
sh "$SCRIPT_PATH"/scripts/render.sh
sh "$SCRIPT_PATH"/scripts/render-cat.sh
