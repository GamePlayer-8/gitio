#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

echo '<!DOCTYPE html>' > index.html
echo '<html lang="en-US">' >> index.html
cat docs/head.html >> index.html

echo '<body>' >> index.html
echo '<div class="content">' >> index.html
sh "$SCRIPT_PATH"/documentation/markdown README.md >> index.html
echo '</div>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html
