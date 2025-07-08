{ lib, ... }:
{
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.enum [
              "x86_64-linux"
              "aarch64-linux"
            ];
          };
          profile = lib.mkOption {
            type = lib.types.enum [
              "desktop"
              "server"
            ];
          };
          platform = lib.mkOption {
            type = lib.types.enum [
              "non-nixos"
              "nixos"
              "rpi-nixos"
              "mobile"
              #"darwin"
            ];
          };
          users = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule {
                options = {
                  root.enable = lib.mkEnableOption "root access";
                  shell = lib.mkOption {
                    type = lib.types.enum [
                      "bash"
                      "zsh"
                      "fish"
                      "nushell"
                    ];
                  };
                };
              }
            );
          };
        };
      }
    );
    default = { };
  };
}
