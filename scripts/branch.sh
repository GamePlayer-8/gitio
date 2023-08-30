#!/bin/bash

GIT_BRANCH="${GIT_BRANCH:-'pages'}"
GIT_USERNAME="${GIT_USERNAME:-'user'}"
GIT_TOKEN="${GIT_TOKEN:-'token'}"
GIT_EMAIL="${GIT_EMAIL:-'example@example.com'}"
GIT_HOST="${GIT_HOST:-'github.com'}"
GIT_DIR="${GIT_DIR:-'/runner/page'}"

git config --global credential.helper store
git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
git config --global http.postBuffer 524288000
git config --global init.defaultBranch "$GIT_BRANCH"

echo "Checking https://${GIT_HOST}/${GIT_USERNAME}/${GIT_PROJECT_NAME}..."

if [ "$GIT_HOST" = "github.com" ]; then
    http_response=$(curl -s -o /dev/null -w "%{http_code}" -u "$GIT_USERNAME:$GIT_TOKEN" -X GET https://api.github.com/repos/"$GIT_USERNAME"/"$GIT_PROJECT_NAME"/branches/"$GIT_BRANCH")
else
    http_response=404 # $(curl -s -o /dev/null -w "%{http_code}" -u "$GIT_USERNAME:$GIT_TOKEN" -X GET )
fi

echo 'EXIT CODE '"$http_response"

cd "${GIT_DIR%/*}"

if [ -z "$SYSTEM_TOKEN" ]; then
    url='https://'$GIT_USERNAME:$GIT_TOKEN@"$GIT_HOST"'/'"$GIT_USERNAME"'/'"$GIT_REPO"
else
    url='git@'"$GIT_HOST"':'"$GIT_USERNAME"'/'"$GIT_REPO"'.git'
fi

if [ $http_response -eq 200 ]; then
    git clone -b "$GIT_BRANCH" "$url" "$GIT_BRANCH"

    rm -rf "$(basename "$GIT_DIR")"/.git
    mv "$GIT_BRANCH"/.git "$(basename "$GIT_DIR")"/

    rm -rf "$GIT_BRANCH"
    cd "$(basename "$GIT_DIR")"
else
    cd "$(basename "$GIT_DIR")"
    rm -rf .git
    git init
fi

git branch -m "$GIT_BRANCH"
git add -A
git commit -m "BRANCH synchronization at $(date +%Y-%m-%d)"

git remote remove origin 2>/dev/null 3>&2
git remote add origin "$url"

echo "Pushing to 'https://$GIT_HOST/$GIT_USERNAME/$GIT_PROJECT_NAME'..."

if [ -z "$SYSTEM_TOKEN" ]; then
    echo "https://$GIT_USERNAME:$GIT_TOKEN@$GIT_HOST" > ~/.git-credentials
fi

git push -f -u origin "$GIT_BRANCH"

