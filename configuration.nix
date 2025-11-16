_: {
  imports = [ ./utils/options.nix ];

  hosts = {
    fi-srv-1 = {
      system = "x86_64-linux";
      profile = "server";
      platform = "nixos";
    };
    fi-srv-2 = {
      system = "x86_64-linux";
      profile = "server";
      platform = "nixos";
    };
    fi-srv-3 = {
      system = "x86_64-linux";
      profile = "server";
      platform = "nixos";
    };

    kms = {
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
        #os1 = {
        #  root.enable = true;
        #  shell = "nushell";
        #};
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
