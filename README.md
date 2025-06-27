# 🐧 Modular NixOS Configuration

This repository uses a modular structure for managing NixOS and Home Manager configurations with support for multiple hosts and users.

---

## 📁 Project Structure

* **`./configuration.nix`**
  Main entrypoint for defining:

  * Hosts and users
  * Flake output generation
  * Cross-cutting system & user settings (e.g. shells)

* **`./hosts/${hostname}/default.nix`**
  Host-specific NixOS system settings

* **`./hosts/${hostname}/users/${username}/default.nix`**
  User-specific settings under each host

---

## 🚀 Usage

### 🖥️ Create a New Host

```bash
mkHost
```

Creates a new host scaffold under `./hosts`.

---

### 👤 Create a New User

```bash
mkUser
```

Adds a new user configuration under the given host directory.

---

### ⚙️ Configure a Host

Edit your `configuration.nix` found at root level of repository and add a host
definition:

```nix
{ ... }: {
  hosts.my_hostname = {
    arch = "x86_64-linux";
    type = "desktop";
    platform = "nixos";
    users = {
      my_user = {
        root.enable = true;
        shell = "zsh";
      };
    };
  };
}
```

---

## ☁️ Remote Installation (Terraform)

<details>
<summary>Deploy with Terraform</summary>

Initialize and apply the Terraform setup for provisioning:

```bash
terraform init
terraform apply
```

</details>
