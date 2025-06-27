{ lib, ... }:
{
  hosts = {
    t851 = {
      arch = "x86_64-linux";
      type = "desktop";
      platform = "non-nixos";
      users = {
        os1 = {
          root.enable = true;
          shell = "nushell";
        };
      };
    };
    laptop = {
      arch = "x86_64-linux";
      type = "desktop";
      platform = "nixos";
      users = {
        unixpariah = {
          root.enable = true;
          shell = "nushell";
        };
      };
    };
    laptop-huawei = {
      arch = "x86_64-linux";
      type = "desktop";
      platform = "nixos";
      users.unixpariah = {
        root.enable = true;
        shell = "nushell";
      };
    };
    server-0 = {
      arch = "x86_64-linux";
      type = "server";
      platform = "nixos";
      users.unixpariah = {
        root.enable = true;
        shell = "bash";
      };
    };
    agent-0 = {
      arch = "x86_64-linux";
      type = "server";
      platform = "nixos";
      users.unixpariah = {
        root.enable = true;
        shell = "bash";
      };
    };
    mi10lite = {
      arch = "aarch64-linux";
      type = "mobile";
      platform = "non-nixos";
      users.unixpariah = {
        root.enable = true;
        shell = "bash";
      };
    };
  };
}
