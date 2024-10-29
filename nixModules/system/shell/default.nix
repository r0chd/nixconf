{ conf, pkgs, lib, std }: {
  options.shell =
    lib.mkOption { type = lib.types.enum [ "fish" "zsh" "bash" ]; };

  imports = [
    (import ./fish { inherit conf pkgs lib std; })
    (import ./zsh { inherit conf pkgs lib; })
    (import ./bash { inherit conf pkgs lib; })
  ];
}
