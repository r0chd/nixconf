{ pkgs, config, ... }:
{
  imports = [ ./ssh.nix ];

  sops.secrets = {
    "wireless/SaltoraUp" = {
      sopsFile = ./secrets/secrets.yaml;
    };
    "wireless/Saltora" = {
      sopsFile = ./secrets/secrets.yaml;
    };
    "wireless/T-Mobile_5G_HomeOffice_2.4GHz" = {
      sopsFile = ./secrets/secrets.yaml;
    };
    "wireless/Internet_Domowy_5G_660ECA" = {
      sopsFile = ./secrets/secrets.yaml;
    };
    "wireless/Internet_Domowy_660ECA" = {
      sopsFile = ./secrets/secrets.yaml;
    };
  };

  networking = {
    nameservers = [ "1.1.1.1" ];

    wireless.iwd = {
      enable = true;
      networks = {
        SaltoraUp.psk = config.sops.secrets."wireless/SaltoraUp".path;
        Saltora.psk = config.sops.secrets."wireless/Saltora".path;
        "=542d4d6f62696c655f35475f486f6d654f66666963655f322e3447487a".psk =
          config.sops.secrets."wireless/T-Mobile_5G_HomeOffice_2.4GHz".path;
        Internet_Domowy_660ECA.psk = config.sops.secrets."wireless/Internet_Domowy_660ECA".path;
        Internet_Domowy_5G_660ECA.psk = config.sops.secrets."wireless/Internet_Domowy_5G_660ECA".path;
      };
    };
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = [ pkgs.helix ];
  };
}
