{ lib, config, ... }:
let
  cfg = config.workspace.php;
in
{
  options.workspace.php = {
    enable = lib.mkEnableOption "php";
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      "workspace/php/.envrc".text = ''use flake . --impure'';
      "workspace/php/flake.nix".source = ./flake.nix;
    };
  };
}
