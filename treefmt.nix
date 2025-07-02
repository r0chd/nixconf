{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  settings.on-unmatched = "info";

  programs.nixfmt = {
    enable = true;
    strict = true;
  };

  # https://github.com/google/keep-sorted
  programs.keep-sorted = {
    enable = true;
    priority = 100; # run after other formatters
  };
}
