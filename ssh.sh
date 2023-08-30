#!/bin/sh

GIT_HOST="${GIT_HOST:-'github.com'}"
SYSTEM_TOKEN="${SYSTEM_TOKEN:-'ERROR'}"
HOME="${HOME:-'/'}"

mkdir -p "$HOME"/.ssh 2>/dev/null 3>&2
echo "$SYSTEM_TOKEN" > "$HOME"/.ssh/ci
chmod 600 "$HOME"/.ssh/ci

echo "$HOME"/.ssh/ci >> "$HOME"/.ssh/authorized_keys

echo "   IdentityFile $HOME/.ssh/ci" >> /etc/ssh/ssh_config

eval "$(ssh-agent -s)"

ssh -T git@"$GIT_HOST"
