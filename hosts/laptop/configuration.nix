{
  username,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.nixvim.packages.${system}.default
    sops
  ];
  imports = [
    ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  yubikey.enable = true;

  home-manager.users.${username} = {
    imports = [ ./users/unixpariah/configuration.nix ];
  };

  root = "sudo";

  systemUsers = {
    "unixpariah" = {
      enable = true;
      root.enable = true;
    };
  };

  users.users."unixpariah".shell = pkgs.fish;
  programs.fish.enable = true;
  programs.zsh.enable = true;
  environment.interactiveShellInit =
    # bash
    ''
      if [ -z "$TMUX" ]; then
        i=0
        while true; do
            session_name="base-$i"
            if tmux has-session -t "$session_name" 2>/dev/null; then
                clients_count=$(tmux list-clients | grep $session_name | wc -l)
                if [ $clients_count -eq 0 ]; then
                    tmux attach-session -t $session_name
                    break
                fi
                ((i++))
            else
                tmux new-session -d -s $session_name
                tmux attach-session -d -t $session_name
                break
            fi
        done
      fi
    '';
  security.pam.services.hyprlock = { };
  impermanence = {
    enable = true;
    persist = {
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
      ];
      files = [ ];
    };
  };
  wireless.enable = true;
  power.enable = true;
  bluetooth.enable = true;
  audio.enable = true;
  boot.program = "grub";
  virtualisation.enable = true;
  zram.enable = true;
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  ydotool.enable = true;
  system.stateVersion = "24.11";
  sops = {
    secrets = {
      "ssh_keys/unixpariah" = {
        owner = "unixpariah";
        path = "/home/unixpariah/.ssh/id_ed25519";
      };
    };
  };
}
