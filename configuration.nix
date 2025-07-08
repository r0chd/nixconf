{ ... }:
{
  hosts = {
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
      users.unixpariah = {
        root.enable = true;
        shell = "nushell";
      };
    };
    server-0 = {
      system = "x86_64-linux";
      profile = "server";
      platform = "nixos";
      users.unixpariah = {
        root.enable = true;
        shell = "bash";
      };
    };
    agent-0 = {
      system = "x86_64-linux";
      profile = "server";
      platform = "nixos";
      users.unixpariah = {
        root.enable = true;
        shell = "bash";
      };
    };
    mi10lite = {
      system = "aarch64-linux";
      profile = "mobile";
      platform = "non-nixos";
      users.unixpariah = {
        root.enable = true;
        shell = "bash";
      };
    };
  };
}
