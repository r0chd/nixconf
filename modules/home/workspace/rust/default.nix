{ config, lib, ... }:
let
  cfg = config.workspace.rust;
in

{
  options.workspace.rust.enable = lib.mkEnableOption "rust";

  config = lib.mkIf cfg.enable {
    home.file = {
      "workspace/rust/.envrc".text = ''use flake . --impure'';
      "workspace/rust/flake.nix".source = ./flake.nix;
    };
  };
}
