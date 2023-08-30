# Use a suitable base image
FROM alpine

# Set metadata for the action
LABEL "com.github.actions.name"="GitIO"
LABEL "com.github.actions.description"="An I/O for the Git server communication & builder."
LABEL "com.github.actions.icon"="docs/gitio.png"
LABEL "com.github.actions.color"="orange"

RUN apk add --no-cache podman fuse-overlayfs gawk tar gzip git jq curl wget

RUN cp pipeline/containers.conf /etc/containers/containers.conf
RUN chmod 644 /etc/containers/containers.conf && \
    sed -i -e 's|^#mount_program|mount_program|g' -e \
    '/additionalimage.*/a "/var/lib/shared",' -e \
    's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
    /etc/containers/storage.conf && \
    mkdir -p /var/lib/shared/overlay-images \
    /var/lib/shared/overlay-layers /var/lib/shared/vfs-images \
    /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock && \
    mkdir /listen

# Copy the action's code into the container
RUN mkdir /gitio-docs
COPY ./scripts/* /scripts/
COPY ./LICENSE.txt /gitio-docs/
COPY ./README.md /gitio-docs/
COPY ./docs/gitio.png /gitio-docs/
COPY ./runtime.sh /gitio-runtime.sh

RUN chmod +x /gitio-scripts/* && \
    chmod +x /gitio-runtime.sh
