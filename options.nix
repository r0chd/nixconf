{ lib, ... }:
{
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options = {
          system = lib.mkOption { type = lib.types.enum [ "x86_64-linux" ]; };
          profile = lib.mkOption {
            type = lib.types.enum [
              "desktop"
              "server"
              "mobile"
            ];
          };
          platform = lib.mkOption {
            type = lib.types.enum [
              "non-nixos"
              "nixos"
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
