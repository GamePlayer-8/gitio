# Use a suitable base image
FROM alpine

# Set metadata for the action
LABEL "com.github.actions.name"="GitIO"
LABEL "com.github.actions.description"="An I/O for the Git server communication & builder."
LABEL "com.github.actions.author"="Chimmie Firefly"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="orange"

RUN apk add --no-cache tar gzip git openssh jq curl gawk coreutils

# Build Kaniko
RUN apk add --no-cache go bash build-base binutils && \
    git clone --recursive https://codeberg.org/mirri/kaniko /kaniko-src && \
    cd /kaniko-src && \
    make && \
    mv out/executor /usr/bin/kaniko && \
    strip /usr/bin/kaniko && \
    apk del go build-base && \
    cd / && rm -rf /kaniko-src && \
    chmod +x /usr/bin/kaniko && \
    echo 'OK' > /tmp/kaniko.ci && \
    echo 'OK' > /tmp/gitio.ci && \
    echo 'OK' > /tmp/gitio-ssh.ci

WORKDIR /

COPY packages/default-fs/. .

RUN chmod +x /usr/bin/gitio
