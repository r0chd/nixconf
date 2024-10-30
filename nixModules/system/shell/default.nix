{ config, pkgs, lib, std, username, ... }: {
  options.shell =
    lib.mkOption { type = lib.types.enum [ "fish" "zsh" "bash" ]; };

  imports = [
    (import ./fish {
      inherit pkgs lib std username;
      conf = config;
    })
    (import ./zsh {
      inherit pkgs lib username;
      conf = config;
    })
    (import ./bash {
      inherit pkgs lib username;
      conf = config;
    })
  ];
}
