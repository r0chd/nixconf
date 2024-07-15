{
  inputs,
  pkgs,
  lib,
  config,
  hostname,
  ...
}: let
  userConfig = {
    username = "unixpariah";
    hostname = hostname;
    colorscheme = "catppuccin";
    editor = "nvim";
    wireless = true;
    disableAll = true;
    power = true;
    boot = {
      loader = "systemd-boot";
      legacy = true;
    };
  };
in {
  imports = [
    (import ../../nixModules/default.nix {inherit userConfig inputs pkgs lib config;})
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [unzip];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "24.05";
}
