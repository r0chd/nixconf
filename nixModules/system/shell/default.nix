{ conf, pkgs, lib }: {
  options.shell =
    lib.mkOption { type = lib.types.enum [ "fish" "zsh" "bash" ]; };

  imports = [
    (import ./fish { inherit conf pkgs lib; })
    (import ./zsh { inherit conf pkgs lib; })
    (import ./bash { inherit conf pkgs lib; })
  ];
}
