{ ... }:
{
  impermanence.persist.directories = [ ".ssh" ];
  programs.ssh = {
    enable = true;
    extraConfig = "AddKeysToAgent yes";
  };
}
