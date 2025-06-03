# NixOS configuration

Modular NixOs config

# Installation

### Create a New Host

```
mkHost
```

### Create a New User

```
mkUser
```

### Configure the Host

Edit flake.nix and add a new host in the let block:

```nix
let
  hosts.my_hostname = {
    arch = "x86_64-linux"; # Architecture of your machine
    type = "desktop";      # Type: desktop, server, or mobile
    users = {
      my_user = {
        root.enable = true;  # Add to wheel group
        shell = "zsh";       # Shell: bash, zsh, or nushell
      };
    };
  };
in
```

<details>
  <summary>Remote installation</summary>

  Initialize terraform

  ```bash
  terraform init
  ```

  apply terraform

  ```bash
  terraform apply
  ```
</details>
