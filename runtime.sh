#!/bin/bash

CMD_TYPE="${CMD_TYPE:-'checkout'}"
CMD="${CMD:-''}"

IFS=' ' read -ra CMD_ARRAY <<< "$CMD"
CMD_ARRAY=("${CMD_ARRAY[@]/''}")

checkout() {
    if [ -z "$SYSTEM_TOKEN" ]; then
        url='https://'$GIT_USERNAME:$GIT_TOKEN@"$GIT_HOST"'/'"$GIT_USERNAME"'/'"$GIT_REPO"
    else
        url='git@'"$GIT_HOST"':'"$GIT_USERNAME"'/'"$GIT_REPO"'.git'
    fi
    git clone "$CMD" "$url"
    exit $?
}

container() {
    for element in "${CMD_ARRAY[@]}"
    do
        if ! [[ $element == *":"* ]]; then
            echo 'Missing data syntax in '"$element"'. Exiting...'
            exit 1
        fi
        IFS=":" read -r name value <<< "$element"
        export "$name=$value"
    done

    SCRIPT_PATH="$(dirname "$(realpath "$0")")"
    bash "$SCRIPT_PATH"/scripts/deploy-container.sh
}

branch() {
    for element in "${CMD_ARRAY[@]}"
    do
        if ! [[ $element == *":"* ]]; then
            echo 'Missing data syntax in '"$element"'. Exiting...'
            exit 1
        fi
        IFS=":" read -r name value <<< "$element"
        export "$name=$value"
    done

    SCRIPT_PATH="$(dirname "$(realpath "$0")")"
    bash "$SCRIPT_PATH"/scripts/branch.sh

}

case "$CMD_TYPE" in
    "checkout")
        checkout
        ;;
    "container")
        container
        ;;
    "branch")
        branch
        ;;
esac
