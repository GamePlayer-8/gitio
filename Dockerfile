# Use a suitable base image
FROM alpine

# Set metadata for the action
LABEL "com.github.actions.name"="GitIO"
LABEL "com.github.actions.description"="An I/O for the Git server communication & builder."
LABEL "com.github.actions.author"="Chimmie Firefly"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="orange"

RUN apk add --no-cache tar gzip git openssh jq curl gawk coreutils

# Install docker
RUN apk add --no-cache docker

# Build Kaniko
RUN apk add --no-cache go && \
    git clone --recursive https://github.com/GoogleContainerTools/kaniko /kaniko && \
    cd /kaniko && \
    make && \
    mv out/executor /usr/bin/kaniko && \
    chmod +x /usr/bin/kaniko && \
    apk purge go && \
    cd / && rm -rf kaniko

WORKDIR /

COPY packages/default-fs/. .

RUN chmod +x /usr/bin/gitio
