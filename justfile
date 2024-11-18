default:
    @just --list

rebuild:
    @nix build ".#nixosConfigurations.$(hostname).config.system.build.toplevel" --log-format internal-json -v --out-link /tmp/prev |& nom --json
    @nvd diff /run/current-system /tmp/prev


rebuild-update:
    @nix flake update
    @just rebuild
