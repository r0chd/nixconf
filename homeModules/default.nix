{
  pkgs,
  lib,
  username,
  shell,
  ...
}:
{
  imports = [
    ./gaming
    ./environment
    ./programs
    ./security
    ./network
    ./system
    ./apps
    ../hosts/laptop/users/${username}/configuration.nix
  ];

  options = {
    email = lib.mkOption { type = lib.types.str; };
  };

  config = {
    #nixpkgs.overlays = [
    #  (final: prev: {
    #    libuv = prev.libuv.overrideAttrs (old: {
    #      postPatch =
    #        (old.postPatch or "")
    #        + ''
    #          sed '/fs_utime_round/d' -i test/test-list.h
    #        '';
    #    });
    #  })
    #  (self: super: {
    #    isl = super.isl.overrideAttrs (oldAttrs: {
    #      src = super.fetchurl {
    #        urls = [
    #          "https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.20.tar.xz"
    #        ];
    #        sha256 = oldAttrs.src.sha256;
    #      };
    #    });
    #  })
    #];

    services.hyprpaper.enable = lib.mkForce false; # TODO: Remove these once wallpaper is optionalized in stylix
    stylix.targets.hyprpaper.enable = lib.mkForce false;

    programs.home-manager.enable = true;
    home = {
      sessionVariables.HOME_MANAGER_BACKUP_EXT = "bak";
      packages = with pkgs; [
        (writeShellScriptBin "shell" ''
          nix develop "/var/lib/nixconf#devShells.$@.${pkgs.system}" -c ${shell}
        '')
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
      ];
      username = username;
      homeDirectory = "/home/${username}";
      stateVersion = "24.11";
    };

    specialisation = {
      Wayland.configuration = {
        environment.session = "Wayland";
      };
      X11.configuration = {
        environment.session = "X11";
      };
    };
  };
}
