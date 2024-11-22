{
  pkgs,
  lib,
  username,
  ...
}:
{
  options = {
    outputs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            position = {
              x = lib.mkOption { type = lib.types.int; };
              y = lib.mkOption { type = lib.types.int; };
            };
            refresh = lib.mkOption { type = lib.types.float; };
            dimensions = {
              width = lib.mkOption { type = lib.types.int; };
              height = lib.mkOption { type = lib.types.int; };
            };
            scale = lib.mkOption {
              type = lib.types.int;
              default = 1;
            };
          };
        }
      );
      default = { };
    };
    font = lib.mkOption { type = lib.types.str; };
    email = lib.mkOption { type = lib.types.str; };
  };
  imports = [
    ./environments
    ./tools
    ./gaming
    ./gui
    ./colorschemes.nix
    ./security
    ./network
    ./system
  ];
  config = {
    window-manager = {
      enable = true;
      backend = "Wayland";
      name = "niri";
    };
    programs.home-manager.enable = true;
    home = {
      packages = with pkgs; [
        just
        nvd
        nix-output-monitor
        # (writeShellScriptBin "shell" ''
        #   nix develop "${../shells#devShells.$@.${pkgs.system}}" -c ${config.users.${user}.shell}
        # '')
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
      ];
      username = username;
      homeDirectory = "/home/unixpariah";
      stateVersion = "24.11";
    };

    # specialisation = {
    #   Hyprland.configuration =
    #     {
    #     };
    #   sway.configuration =
    #     {
    #     };
    #   niri.configuration =
    #     {
    #     };
    #   i3.configuration =
    #     {
    #     };
    # };
  };
}
