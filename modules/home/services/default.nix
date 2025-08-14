{
  inputs,
  profile,
  ...
}:
{
  imports = [
    inputs.sysnotifier.homeManagerModules.default
    inputs.moxapi.homeManagerModules.default
    ./impermanence
    ./yubikey-touch-detector
    ./ngrok
    ./cliphist
    ./darkfirc
    ./gc
  ];

  services = {
    udiskie.enable = profile == "desktop";
    sysnotifier.enable = profile == "desktop";
    hyprpolkitagent.enable = profile == "desktop";
    #moxapi.enable = profile == "desktop";
  };
}
