# syntax=docker/dockerfile:1.3
FROM alpine:latest

LABEL org.opencontainers.image.authors="Cameron (ca33r0n1) <cameron@auraside.com>"
LABEL org.opencontainers.image.version="1.0.4"
LABEL org.opencontainers.image.vendor="AuraSide Inc."

# Allow connectivity to MC Server Port
EXPOSE 25565/tcp
EXPOSE 25575/tcp

# BuildX Things
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

# Set how to stop the server.
STOPSIGNAL SIGTERM

# Env args that are required
ARG weburl
ARG servertype
ARG servergroup
ARG jenkinskey

# Install Applications to the OS
RUN apk add --no-cache curl unzip openjdk8 wget nfs-utils

# Setup the Base Dir's
RUN mkdir /data
WORKDIR /data

# Create the MC Group & user.
RUN addgroup --gid 1000 minecraft && adduser --system --shell /bin/false --uid 1000 --ingroup minecraft --home /data minecraft

COPY "runner.sh" "/data/runner.sh"

#RUN wget -O runner.sh https://${weburl}/${servergroup}/${servertype}-install.sh

RUN chmod +x runner.sh

ENTRYPOINT ["/bin/sh","/data/runner.sh", ${weburl}, ${servergroup}, ${servertype}, ${jenkinskey}]
