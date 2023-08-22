#!/bin/bash

CMD_TYPE="${$1:-'checkout'}"
CMD="${$2:-''}"

case "$CMD_TYPE" in
    "checkout")
