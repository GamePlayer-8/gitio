#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

echo '<!DOCTYPE html>' > index.html
echo '<html lang="en-US">' >> index.html
cat res/head.html >> index.html

echo '<body>' >> index.html
echo '<div class="content">' >> index.html
markdown README.md >> index.html
echo '</div>' >> index.html
echo '</body>' >> index.html
echo '</html>' >> index.html
