#!/bin/sh

INSTALLER="${INSTALLER:-'apt install -y wget curl'}"

exec $INSTALLER

git clone -b main --recursive https://codeberg/GamePlayer-8/gitio /gitio
