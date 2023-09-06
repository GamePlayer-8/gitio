# Use a suitable base image
FROM alpine

# Set metadata for the action
LABEL "com.github.actions.name"="Kaniko"
LABEL "com.github.actions.description"="A simple container with kaniko command."
LABEL "com.github.actions.author"="Chimmie Firefly"
LABEL "com.github.actions.icon"="activity"
LABEL "com.github.actions.color"="blue"

# Install docker
RUN apk add --no-cache docker

# Build Kaniko
RUN apk add --no-cache go bash build-base binutils && \
    git clone --recursive https://github.com/GoogleContainerTools/kaniko /kaniko-src && \
    cd /kaniko-src && \
    make && \
    mv out/executor /usr/bin/kaniko && \
    strip /usr/bin/kaniko && \
    apk del go build-base && \
    cd / && rm -rf /kaniko-src && \
    chmod +x /usr/bin/kaniko

CMD ["/usr/bin/kaniko"]
