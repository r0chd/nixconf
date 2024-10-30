{ config, lib, std, inputs, username, ... }: {
  imports = [
    ./bootloader
    ./shell
    ./virtualization
    ./zram
    (import ./impermanence {
      inherit lib std inputs username;
      conf = config;
    })
  ];
}
