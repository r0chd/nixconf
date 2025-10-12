{
  profile,
  ...
}:
{
  imports = [
    ./impermanence
    ./yubikey-touch-detector
    ./ngrok
    ./cliphist
    ./darkfirc
    ./gc
  ];

  services = {
    udiskie.enable = profile == "desktop";
    #sysnotifier.enable = profile == "desktop";
    hyprpolkitagent.enable = profile == "desktop";
    mpris-proxy.enable = profile == "desktop";
  };
}
