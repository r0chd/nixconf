default:
    @just --list

rebuild:
    @nh os switch

rebuild-full:
    @nix flake update
    just rebuild
