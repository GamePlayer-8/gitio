#!/bin/sh

# A worker is for processing stuff defined by the repo.

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
INSTALLER="$SCRIPT_PATH"/packages/default-fs/usr/share/gitio/scripts/insti.sh

sh "$SCRIPT_PATH"/packages/build.sh
rm -rf "$SCRIPT_PATH"/.gitignore

sh "$INSTALLER" sed

echo '<!DOCTYPE html>' > index.html
echo '<html lang="en-US">' >> index.html
cat docs/head.html >> index.html

echo '<body>' >> index.html
echo '<div class="content">' >> index.html
sh "$SCRIPT_PATH"/documentation/markdown README.md >> index.html
echo '</div>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html

sh "$SCRIPT_PATH"/documentation/render.sh
sh "$SCRIPT_PATH"/documentation/render_cat.sh

cd "$SCRIPT_PATH"
sh install.sh
