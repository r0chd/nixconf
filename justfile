default:
    @just --list

generation:
    @readlink /nix/var/nix/profiles/system

specialisation:
    @cat /etc/specialisation 2>/dev/null || echo none

home-specialisation:
    @cat ~/.local/share/home-manager/specialisation 2>/dev/null || echo none

gen-database:
    nix run github:nix-community/nix-index#nix-index
