{ inputs, pkgs, ... }:
{
  programs = {
    nh = {
      enable = true;
      package = inputs.nh.packages.${pkgs.stdenv.hostPlatform.system}.default;
      flake = "/var/lib/nixconf";
    };
    nushell.environmentVariables.NH_FLAKE = "/var/lib/nixconf";
  };
}
