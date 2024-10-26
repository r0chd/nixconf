{ conf, pkgs, lib, std, inputs }: {
  imports = [
    (import ./bootloader { inherit conf lib; })
    (import ./shell { inherit conf pkgs lib; })
    (import ./virtualization { inherit conf lib; })
    (import ./zram { inherit conf lib; })
    (import ./impermanence { inherit conf lib std inputs; })
  ];
}
