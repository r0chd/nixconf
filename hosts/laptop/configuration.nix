{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  systemUsers = {
    "unixpariah" = {
      enable = true;
      root.enable = true;
    };
  };
  gc = {
    enable = true;
    interval = 3;
  };
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
  ydotool.enable = true;
  yubikey.enable = true;

  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      inputs.nixvim.packages.${system}.default
    ];
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

  sops.secrets = {
    "ssh_keys/unixpariah" = {
      owner = "unixpariah";
      path = "/persist/home/unixpariah/.ssh/id_ed25519";
    };
    "ssh_keys/unixpariah-yubikey" = {
      owner = "unixpariah";
      path = "/persist/home/unixpariah/.ssh/id_yubikey";
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11";
}
