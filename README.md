# NixOS configuration

Configuration trying to be as modular and as pure as possible

## Installation

1. Clone the repository

```bash
git clone git@github.com:unixpariah/nixconf.git ~/nixconf
```

2. Create config at `~/nixconf/hosts/{hostname}/configuration.nix`

3. Update flake.nix

```diff
  outputs = {
    nixpkgs,
    disko,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
+     {hostname} = nixpkgs.lib.nixosSystem {
+       specialArgs = {inherit inputs;};
+       modules = [
+         ./hosts/{hostname}/configuration.nix
+         disko.nixosModules.default
+         home-manager.nixosModules.default
+         {
+           nixpkgs.system = "x86_64-linux";
+         }
+       ];
+     };
    };
  };
```

3. Rebuild your system

```bash
doas nixos-rebuild switch --flake ~/nixconf#laptop
```

```bash
nh os switch -H laptop
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
- [ ] Disko (with full luks encryption)
- [ ] Impermamence
- [ ] NixOS anywhere
- [ ] Setup script (maybe even with gui)
