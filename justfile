default:
    @just --list

generation:
    @readlink /nix/var/nix/profiles/system

switch:
    sudo nix-env -p /nix/var/nix/profiles/system --set /tmp/$(just generation)/result
    sudo /tmp/$(just generation)/result/bin/switch-to-configuration switch

rebuild:
    @nix build ".#nixosConfigurations.$(hostname).config.system.build.toplevel" --log-format internal-json -v --out-link /tmp/$(just generation)/result |& nom --json
    @nvd diff /run/current-system /tmp/$(just generation)/result

rebuild-switch:
    @just rebuild
    @just switch

rebuild-switch-update:
    @nix flake update
    @just rebuild-switch
