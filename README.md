My NixOs configuration for both wayland and xorg

If you want to build xorg run this command:

```bash
rebuild-xorg
```

or this:

```bash
doas nixos-rebuild switch --flake ~/nixconf/#xorgconf
```

------------------------------------------------------

If you want to build wayland run this command:

```bash
rebuild-wayland
```

or this:

```bash
doas nixos-rebuild switch --flake ~/nixconf/#waylandconf
```

After rebuilding you should reboot your system
