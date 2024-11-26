ROOT := `which sudo > /dev/null 2>&1 && echo sudo || echo doas`
GENERATION := `readlink /nix/var/nix/profiles/system | awk -F'-' '{print $1"-"($2+1)"-"$3}'`
CONFIGURATION_PATH := `cat /etc/specialisation > /dev/null 2>&1 && echo /result/specialisation/$(cat /etc/specialisation) || echo /result/`

HOME_ACTIVATION_PATH := `home-manager generations | head -1 | awk '{print $NF}'`

default:
    @just --list

generation:
    @readlink /nix/var/nix/profiles/system

specialisation:
    @cat /etc/specialisation 2>/dev/null || echo none

switch:
    @nix-env -p /nix/var/nix/profiles/system --set /tmp/{{GENERATION}}/result
    @/tmp/{{GENERATION}}{{CONFIGURATION_PATH}}/bin/switch-to-configuration test
    @nix-env --profile /nix/var/nix/profiles/system --set /tmp/{{GENERATION}}/result
    @/tmp/{{GENERATION}}{{CONFIGURATION_PATH}}/bin/switch-to-configuration boot

rebuild:
    @nix build ".#nixosConfigurations.$(hostname).config.system.build.toplevel" --log-format internal-json -v --out-link /tmp/{{GENERATION}}/result |& nom --json
    @nvd diff /run/current-system /tmp/{{GENERATION}}{{CONFIGURATION_PATH}}

rebuild-switch:
    @just rebuild
    @{{ROOT}} just switch

rebuild-switch-update:
    @nix flake update
    @just rebuild-switch

home-build:
    @nix build ".#homeConfigurations.$(whoami)@$(hostname).config.home.activationPackage" --log-format internal-json --verbose --out-link /tmp/result |& nom --json

home-switch:
    @/tmp/result$(cat /etc/specialisation > /dev/null 2>&1 && echo /specialisation/$(cat /etc/specialisation)/activate || echo /activate) test
    @nvd diff {{HOME_ACTIVATION_PATH}} /tmp/result/$(cat /etc/specialisation > /dev/null 2>&1 && echo /specialisation/$(cat /etc/specialisation))
home-rebuild-switch:
    @just home-build
    @just home-switch

home-rebuild-switch-update:
    @nix flake update
    @just home-rebuild-switch

gen-database:
    nix run github:nix-community/nix-index#nix-index
