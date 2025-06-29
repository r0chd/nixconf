# While this may seem not seem like the most sofisticated way to manage ssh keys,
# it's the most maintainable one when it comes to multiple machines, trust me
{
  hostName,
  lib,
  config,
  ...
}:
let
  keys = {
    deploy-rs = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOBaG0f5JOYQn/JJuvKjH+29rWSuzlv+LUrhVlD7rDkb deploy-rs";
    "unixpariah@laptop" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIt5tKaE1UZuWe22amvR0gpW0HMmvBY5W5E+Bpw6AswA unixpariah@laptop";
    "unixpariah@laptop-huawei" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHlMzZUr5wkZj2AFsQEX2v3Kfaj30q77YmAAkdlH/Fi unixpariah@laptop";
    "os1@t851" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ/oAHQPuhH41A/PFgmF138j0eWkmZo0i2Jtl/OMBILD os1@qed.ai";
  };

  hosts = {
    "t851" = {
      "os1" = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys.deploy-rs
      ];
    };

    "laptop" = {
      "unixpariah" = [
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
        keys.deploy-rs
      ];
    };

    "laptop-huawei" = {
      "unixpariah" = [
        keys."unixpariah@laptop"
        keys."os1@t851"
        keys.deploy-rs
      ];
    };

    "agent-0" = {
      "unixpariah" = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
        keys.deploy-rs
      ];
    };

    "server-0" = {
      "unixpariah" = [
        keys."unixpariah@laptop"
        keys."unixpariah@laptop-huawei"
        keys."os1@t851"
        keys.deploy-rs
      ];
    };
  };
in
{
  users.users = lib.genAttrs (hosts.${hostName} |> builtins.attrNames) (user: {
    openssh.authorizedKeys.keys = hosts.${hostName}.${user};
  });

  boot.initrd.network.ssh.authorizedKeys = lib.flatten (
    lib.mapAttrsToList (user: userConfig: userConfig.openssh.authorizedKeys.keys) config.users.users
  );
}
