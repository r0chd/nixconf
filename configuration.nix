_: {
  imports = [ ./utils/options.nix ];

  hosts = {
    rpi = {
      system = "aarch64-linux";
      profile = "server";
      platform = "rpi-nixos";
    };

    fi-srv-1 = {
      system = "x86_64-linux";
      profile = "server";
      platform = "nixos";
    };

    t851 = {
      system = "x86_64-linux";
      profile = "desktop";
      platform = "non-nixos";
      users = {
        os1 = {
          root.enable = true;
          shell = "nushell";
        };
      };
    };
    laptop = {
      system = "x86_64-linux";
      profile = "desktop";
      platform = "nixos";
      users = {
        unixpariah = {
          root.enable = true;
          shell = "nushell";
        };
      };
    };
    laptop-huawei = {
      system = "x86_64-linux";
      profile = "desktop";
      platform = "nixos";
      users = {
        unixpariah = {
          root.enable = true;
          shell = "nushell";
        };
        r0chd = {
          root.enable = true;
          shell = "nushell";
        };
      };
    };
  };
}
