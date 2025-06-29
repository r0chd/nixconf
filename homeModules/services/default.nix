{ inputs, ... }:
{
  imports = [
    inputs.sysnotifier.homeManagerModules.default
    ./impermanence
    ./yubikey-touch-detector
    ./ngrok
    ./cliphist
    ./gc
  ];
}
