{ config, lib, ... }:
let
  cfg = config.workspace.zig;
in

{
  options.workspace.zig.enable = lib.mkEnableOption "zig";

  config = lib.mkIf cfg.enable {
    home.file = {
      "workspace/zig/.envrc".text = ''use flake . --impure'';
      "workspace/zig/flake.nix".source = ./flake.nix;
    };
  };
}
