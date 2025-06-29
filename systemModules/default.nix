{
  config,
  lib,
  pkgs,
  hostName,
  inputs,
  ...
}:
{
  imports = [
    ./environment
    ./services
    ./security
    ./programs
    #./users
    ../hosts/${hostName}
  ];

  #services.userborn.enable = true;

  environment = {
    etc = {
      "udev/rules.d/yubikey.rules".text = ''
        ACTION=="remove",\
        ENV{SUBSYSTEM}=="usb",\
        ENV{PRODUCT}=="1050/407/571",\
        RUN+="/usr/bin/loginctl lock-sessions"
      '';
      "nix/nix.conf".text = ''
        experimental-features = nix-command flakes pipe-operators
        build-users-group = nixbld
      '';
    };
  };

  systemd.services.udev-reload-rules = {
    description = "Reload udev rules";
    wantedBy = [ "system-manager.target" ];
    before = [ "system-manager.target" ];
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      echo "Reloading udev rules..."
      udevadm control --reload-rules
    '';
    restartIfChanged = true;
  };
}
