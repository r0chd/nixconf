{ lib, config, ... }:

let
  keys = {
    "deploy-rs" = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP7UVzSfFNFq1v392BK1+PUyD08L6/hMdF2sF5yGp+IV deploy-rs@laptop-huawei"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxG93Ge43zI7fw/tzzZwtNefNnLgPTZTEdTXwi+LEI9 deploy-rs@laptop"
    ];
    "unixpariah@laptop" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHM/K2ZbUnI91wCATV/kVXEWn02nJ9xsDygb9u1EmWx unixpariah@laptop-huawei";
    "unixpariah@laptop-huawei" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3XG/jXx/zYi7L8H3/KnePWbFg9t44JHHjAn1LZ2eyu unixpariah@laptop-huawei";
    "os1@t851" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/oAHQPuhH41A/PFgmF138j0eWkmZo0i2Jtl/OMBILD os1@qed.ai";
  };

  baseHosts = {
    "t851" = {
      "os1" = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
      ];
    };

    "laptop" = {
      "unixpariah" = [
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };

    "laptop-huawei" = {
      "unixpariah" = [
        keys."unixpariah@laptop"
        keys."os1@t851"
      ];
    };

    "agent-0" = {
      "unixpariah" = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };

    "server-0" = {
      "unixpariah" = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
      ];
    };
  };

  # Automatically inject deploy-rs keys into all hosts
  hosts = lib.mapAttrs (_host: users: users // { inherit (keys) deploy-rs; }) baseHosts;
in
{
  users.users = lib.genAttrs (hosts.${config.networking.hostName} |> builtins.attrNames) (user: {
    openssh.authorizedKeys.keys = hosts.${config.networking.hostName}.${user};
  });

  boot.initrd.network.ssh.authorizedKeys = lib.flatten (
    lib.mapAttrsToList (_user: userConfig: userConfig.openssh.authorizedKeys.keys) config.users.users
  );
}
