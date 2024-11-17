{ lib, ... }: {
  options.shell =
    lib.mkOption { type = lib.types.enum [ "fish" "zsh" "bash" ]; };

  imports = [ ./fish ./zsh ./bash ];
}
