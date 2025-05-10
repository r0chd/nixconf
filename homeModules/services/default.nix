{ inputs, ... }:
{
  imports = [
    inputs.sysnotifier.homeManagerModules.default
    inputs.moxpaper.homeManagerModules.default
    ./impermanence
    ./yubikey-touch-detector
    ./ngrok
  ];
}
