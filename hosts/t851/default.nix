{ ... }:
{
  #programs.niri.enable = true;

  environment.etc."gdm3/custom.conf".text = ''
    # GDM configuration storage
    #
    # See /usr/share/gdm/gdm.schemas for a list of available options.

    # Enabling automatic login

    # Enabling timed login
    #  TimedLoginEnable = true
    #  TimedLogin = user1
    #  TimedLoginDelay = 10

    [security]

    [xdmcp]

    [chooser]

    [debug]
    # Uncomment the line below to turn on debugging
    # More verbose logs
    # Additionally lets the X server dump core if it crashes
    #Enable=true
  '';

  nixpkgs.hostPlatform = "x86_64-linux";
}
