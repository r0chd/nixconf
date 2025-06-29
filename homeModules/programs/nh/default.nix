{ ... }:
{
  programs = {
    nh = {
      enable = true;
      flake = "/var/lib/nixconf";
    };
    nushell.environmentVariables.NH_FLAKE = "/var/lib/nixconf";
  };
}
