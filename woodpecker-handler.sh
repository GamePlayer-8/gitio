#!/bin/sh

SCRIPT_PATH="$(dirname "$(realpath "$0")")"
MODE="${MODE:-$1}"
MODE="${MODE:-''}"

if ! [ -f /tmp/installed.ci ]; then
    sh "$SCRIPT_PATH"/installer.sh
    echo 'OK' > /tmp/installed.ci
fi

if ! [ -d /listen ]; then
    mkdir -p /etc/containers 2>/dev/null 3>&2
    cp "$SCRIPT_PATH"/pipeline/containers.conf /etc/containers/containers.conf
    chmod 644 /etc/containers/containers.conf && \
    sed -i -e 's|^#mount_program|mount_program|g' -e \
    '/additionalimage.*/a "/var/lib/shared",' -e \
    's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
    /etc/containers/storage.conf && \
    mkdir -p /var/lib/shared/overlay-images \
    /var/lib/shared/overlay-layers /var/lib/shared/vfs-images \
    /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock && \
    mkdir /listen
fi

case "$MODE" in
        "env")
            export DEBIAN_FRONTEND=noninteractive
            export TZ="Europe/Warsaw"
            export LOCAL_DIR="$(pwd)"
            export GIT_BRANCH="$(basename "$CI_COMMIT_REF")"
            export GIT_TOKEN="$OCI_TOKEN"
            export GIT_PROJECT_NAME="$CI_REPO_NAME"
            export GIT_USERNAME="$CI_REPO_OWNER"
            export GIT_REPO="$CI_REPO"
            export GIT_HOST="$(echo "$CI_REPO_URL" | awk -F/ '{print $3}')"
            export GIT_DOMAIN="$CI_REPO_OWNER"'.'"$GIT_HOST"
            export GIT_WEBPAGE='https://'"$GIT_DOMAIN"'/'"$CI_REPO_NAME"
            ;;
        "codeberg")
            export GIT_DOMAIN="$CI_REPO_OWNER"'.'"codeberg.page"
            export GIT_WEBPAGE='https://'"$GIT_DOMAIN"'/'"$CI_REPO_NAME"
            ;;
        "ssh")
            sh "$SCRIPT_PATH"/ssh.sh
            ;;
        *)
            if [ -z "$CMD_TYPE" ]; then
                echo 'Please configure CMD_TYPE environment variable.'
                exit 5
            fi
            sh "$SCRIPT_PATH"/runtime.sh
            ;;
esac
