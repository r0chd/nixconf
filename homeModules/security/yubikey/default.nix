{ lib, config, pkgs, std, ... }: {
  options.yubikey = { enable = lib.mkEnableOption "yubikey"; };

  config = lib.mkIf config.yubikey.enable {
    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
      pamu2f
    ];

    services = {
      yubikey-agent.enable = true;
      udev = let lockscreen = config.screenIdle;
      in {
        extraRules = ''
          ACTION=="remove",\
          ENV{ID_BUS}=="usb",\
          ENV{ID_MODEL_ID}=="0407",\
          ENV{ID_VENDOR_ID}=="1050",\
          ENV{ID_VENDOR}=="Yubico",\
          RUN+="${
            (if lockscreen.enable then
              lockscreen.program
            else
              "loginctl lock-sessions")
          }"
        '';

        packages = with pkgs; [ yubikey-personalization ];
      };
    };

    security.pam = {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = true;
          authFile = "${std.dirs.home}/.config/Yubico/u2f_keys";
        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };

    #impermanence.persist.directories =
    #  [ "${std.dirs.home}/.config/Yubico/u2f_keys" ];
  };
}

# ykman fido access change-pin
# ssh-keygen -t ed25519-sk -N "" -C "unixpariah@laptop" -f ~/.ssh/id_of_key
# pamu2fcfg -u user > ~/u2f_keys
