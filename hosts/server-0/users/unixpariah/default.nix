{ config, ... }:
{
  sops.secrets.atuin_key = { };

  programs = {
    editor = "hx";
    vcs.email = "100892812+unixpariah@users.noreply.github.com";
    atuin = {
      enable = true;
      settings.key_path = config.sops.secrets.atuin_key.path;
    };
  };

  services.impermanence.enable = true;
}
