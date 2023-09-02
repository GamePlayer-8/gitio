# Use a suitable base image
FROM alpine

# Set metadata for the action
LABEL "com.github.actions.name"="GitIO"
LABEL "com.github.actions.description"="An I/O for the Git server communication & builder."
LABEL "com.github.actions.author"="Chimmie Firefly"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="orange"

RUN apk add --no-cache gzip tar qemu-system-x86_64 curl jq sed gawk coreutils

WORKDIR /

COPY packages/default-fs/. .

RUN chmod +x /usr/bin/gitio
