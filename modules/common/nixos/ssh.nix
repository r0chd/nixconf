{ lib, config, ... }:

let
  keys = {
    "nixos-anywhere" = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9Ni+XknzGyAHhNxgbZ9TGCCl96PfipvE44PqbS8MqU nixos-anywhere@laptop"
    ];

    "unixpariah@laptop" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC3KCUFx+9Q26DOYrzA/axbc9rSf6m/3DOvE5h/wApI unixpariah@laptop-huawei";
    "unixpariah@laptop-huawei" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3XG/jXx/zYi7L8H3/KnePWbFg9t44JHHjAn1LZ2eyu unixpariah@laptop-huawei";
    "os1@t851" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/oAHQPuhH41A/PFgmF138j0eWkmZo0i2Jtl/OMBILD os1@qed.ai";
  };

  baseHosts = {
    t851 = {
      os1 = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
      ];
    };

    laptop = {
      unixpariah = [
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };

    laptop-huawei = {
      unixpariah = [
        keys."unixpariah@laptop"
        keys."os1@t851"
      ];
    };

    agent-0 = {
      unixpariah = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };

    server-0 = {
      unixpariah = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };

    "fi-srv-1" = {
      root = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };

    kms = {
      root = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };
  };

  hosts = baseHosts |> lib.mapAttrs (_host: users: users // { inherit (keys) nixos-anywhere; });
in
{
  users.users = lib.genAttrs (hosts.${config.networking.hostName} |> builtins.attrNames) (user: {
    openssh.authorizedKeys.keys = hosts.${config.networking.hostName}.${user};
  });

  boot.initrd.network.ssh.authorizedKeys = lib.flatten (
    lib.mapAttrsToList (_user: userConfig: userConfig.openssh.authorizedKeys.keys) config.users.users
  );
}
