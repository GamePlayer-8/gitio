#!/bin/sh

# A worker is for processing stuff defined by the repo.

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

sh "$SCRIPT_PATH"/packages/build.sh
rm -rf "$SCRIPT_PATH"/.gitignore

cd "$SCRIPT_PATH"
sh install.sh
