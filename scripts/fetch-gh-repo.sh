#!/bin/bash

echo "LOCAL_DIR=$(pwd)" >> $GITHUB_ENV
echo "GIT_BRANCH=${GITHUB_REF#refs/heads/}" >> $GITHUB_ENV

cd /
git clone --recursive -b $GIT_BRANCH https://github.com/${{ github.repository_owner }}/${{ github.event.repository.name }} repo
rm -rf "$LOCAL_DIR"
mv repo "$LOCAL_DIR"
