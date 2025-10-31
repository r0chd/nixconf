#!/usr/bin/env bash

set -euo pipefail

mkdir -p root/.ssh
mkdir -p var/lib/nixconf
mkdir -p persist/system/root/.ssh
mkdir -p persist/system/var/lib/nixconf
mkdir tmp

if [[ -z "${SSH_SOURCE_PATH:-}" ]]; then
    echo "Error: SSH_SOURCE_PATH environment variable not set"
    exit 1
fi

NIXCONF_SOURCE_PATH="/var/lib/nixconf"

SECRET_KEY_PATH="/tmp/secret.key"

if [[ -f "$SSH_SOURCE_PATH" ]]; then
    KEY_FILENAME=$(basename "$SSH_SOURCE_PATH")
    
    cp "$SSH_SOURCE_PATH" "root/.ssh/$KEY_FILENAME"
    chmod 600 "root/.ssh/$KEY_FILENAME"
    echo "Copied SSH private key from $SSH_SOURCE_PATH to /root/.ssh/$KEY_FILENAME"
    
    cp "$SSH_SOURCE_PATH" "persist/system/root/.ssh/$KEY_FILENAME"
    chmod 600 "persist/system/root/.ssh/$KEY_FILENAME"
    echo "Copied SSH private key from $SSH_SOURCE_PATH to /persist/system/root/.ssh/$KEY_FILENAME"
else
    echo "Error: SSH private key not found at $SSH_SOURCE_PATH"
    exit 1
fi

if [[ -d "$NIXCONF_SOURCE_PATH" ]]; then
    cp -r "$NIXCONF_SOURCE_PATH"/* var/lib/nixconf/
    echo "Copied nixconf files from $NIXCONF_SOURCE_PATH to /var/lib/nixconf"
    
    cp -r "$NIXCONF_SOURCE_PATH"/* persist/system/var/lib/nixconf/
    echo "Copied nixconf files from $NIXCONF_SOURCE_PATH to /persist/system/var/lib/nixconf"
else
    echo "Warning: nixconf directory not found at $NIXCONF_SOURCE_PATH"
fi

echo "Files copied successfully to staging directory"
