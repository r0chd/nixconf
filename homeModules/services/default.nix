{ inputs, ... }:
{
  imports = [
    inputs.panotify.homeManagerModules.default
    ./impermanence
    ./yubikey-touch-detector
    ./ngrok
  ];
}
