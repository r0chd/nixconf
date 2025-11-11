#!/usr/bin/env bash

set -euo pipefail

mkdir -p root/.ssh
mkdir -p persist/system/root/.ssh
mkdir tmp

if [[ -z "${SSH_SOURCE_PATH:-}" ]]; then
    echo "Error: SSH_SOURCE_PATH environment variable not set"
    exit 1
fi

if [[ -f "$SSH_SOURCE_PATH" ]]; then
    cp "$SSH_SOURCE_PATH" "root/.ssh/id_ed25519"
    chmod 600 "root/.ssh/id_ed25519"
    echo "Copied SSH private key from $SSH_SOURCE_PATH to /root/.ssh/id_ed25519"
    
    cp "$SSH_SOURCE_PATH" "persist/system/root/.ssh/id_ed25519"
    chmod 600 "persist/system/root/.ssh/id_ed25519"
    echo "Copied SSH private key from $SSH_SOURCE_PATH to /persist/system/root/.ssh/id_ed25519"
else
    echo "Error: SSH private key not found at $SSH_SOURCE_PATH"
    exit 1
fi

echo "Files copied successfully to staging directory"
