# syntax=docker/dockerfile:1.3
FROM alpine:3.18.3 

LABEL org.opencontainers.image.authors="Cameron (ca33r0n1) <cameron@auraside.com>"
LABEL org.opencontainers.image.version="1.0.7"
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
RUN apk add --no-cache curl unzip openjdk8 wget nfs-utils openjdk11 openjdk17 redis ca-certificates openrc openssh openssh-server htop nano libstdc++

# Setup the Base Dir's
RUN mkdir /data
WORKDIR /data

COPY "runner.sh" "/data/runner.sh"
COPY "rcon-cli" "/data/rcon-cli"
COPY "mc-server-runner" "/data/mc-server-runner"

RUN chmod +x runner.sh
RUN chmod +x rcon-cli
RUN chmod +x mc-server-runner

ENTRYPOINT "/data/runner.sh" ${weburl} ${servergroup} ${servertype} ${jenkinskey}
