#!/usr/bin/env bash  
set -euo pipefail  
  
nix eval .#nixosConfigurations.fi-srv-1.config.services.k3s.manifests --json > manifests.json
