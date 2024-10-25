{ username, }: {
  home-manager.users."${username}".programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
}
