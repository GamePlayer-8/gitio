#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"

if ! [ -f /tmp/installed.ci ]; then
    sh "$SCRIPT_PATH"/installer.sh
    echo 'OK' > /tmp/installed.ci
fi

export OUTPUT_IMAGE_NAME="$CI_REPO_NAME"':latest'
export REGISTRY_DOMAIN="$(echo "$CI_REPO_URL" | awk -F/ '{print $3}')"
export REGISTRY_USER="$CI_REPO_OWNER"
export LOCAL_DIR="$SCRIPT_PATH"
export DOCKERFILE="$SCRIPT_PATH"
export REGISTRY_TOKEN="$OCI_TOKEN"

sh "$SCRIPT_PATH"/scripts/deploy-container.sh
