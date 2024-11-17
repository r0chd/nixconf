{ ... }: {
  impermanence.persist.directories = [ ".ssh" ];
  programs.ssh = {
    enable = true;
    #extraConfig = lib.mkIf config.yubikey.enable "AddKeysToAgent yes";
  };
}
