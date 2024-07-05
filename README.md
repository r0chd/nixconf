My NixOs configuration

- Rebuild and switch to change the system configuration

```bash
nh os switch -H laptop
```

OR

```bash
doas nixos-rebuild switch --flake ~/nixconf/#laptop
```

## Options

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
