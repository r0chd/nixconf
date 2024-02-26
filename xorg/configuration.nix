{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ./home.nix;};
  };

  services = {
    picom.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = ["intel"];
      displayManager = {
        startx.enable = true;
        lightdm.enable = false;
        autoLogin = {
          enable = true;
          user = "unixpariah";
        };
      };
      displayManager.defaultSession = "none+dwm";
      windowManager.dwm.enable = true;
      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
        };
        touchpad = {
          accelProfile = "flat";
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    xorg.libX11
    xorg.xorgserver
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xf86videointel
    xorg.xf86videoati
    xorg.xf86videonouveau
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
    xorg.xinput
    xclip
    (dwm.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://github.com/unixpariah/dwm/archive/master.tar.gz";
        sha256 = "0xb0lrh6003fjljvdcpfv5bvxqpb6kqzjk3sy6yrhia2xf2irrs4";
      };
      buildInputs = oldAttrs.buildInputs ++ [harfbuzz];
    }))
  ];
}
