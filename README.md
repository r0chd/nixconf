# NixOS configuration

Configuration trying to be as modular and as pure as possible

## Installation

1. Clone the repository

```bash
git clone git@github.com:unixpariah/nixconf.git ~/nixconf
```

2. Create config at `~/nixconf/hosts/{hostname}/configuration.nix` [Config details](https://github.com/unixpariah/nixconf?tab=readme-ov-file#config)

3. Update flake.nix

```diff
  outputs = {nixpkgs, ...} @ inputs: let
    config = hostname: arch:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/${hostname}/configuration.nix
          inputs.home-manager.nixosModules.default
          {
            nixpkgs.system = arch;
          }
        ];
      };
  in {
    nixosConfigurations = {
+       {hostname} = config "{hostname}" "{cpu architecture}";
    };
  };
```

4. Rebuild your system

```bash
doas nixos-rebuild switch --flake ~/nixconf#{hostname}
```

After rebuilding for the first time you can use this command to rebuild your system:

```bash
nh os switch
```

## Config

```
  userConfig = {
    username = "unixpariah";
    hostname = "laptop";
    colorscheme = "catppuccin"; # Options: catppuccin
    font = "JetBrainsMono Nerd Font";
    terminal = "foot"; # Options: kitty, foot
    editor = "nvim"; # Options: nvim
    shell = "zsh"; # Options: fish, zsh | Default: bash
    browser = "qutebrowser"; # Options: firefox, qutebrowser, chromium
    grub = true; # false = systemd-boot, true = grub
    zoxide = true;
    nh = true;
    virtualization = true;
    audio = true;
    wireless = true;
    power = true;
    tmux = true;
  };
```

## Additional information

Config assumes that it's placed in `~/nixconf`, and a bunch of modularity features depend on it

## TODO

- [x] Flakes
- [x] Home manager
- [x] Sops
- [x] Disko
    - [ ] With full encryption
- [x] Impermamence
- [ ] Yubii key authentication
- [ ] Secure boot
- [ ] Setup script 
