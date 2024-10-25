{ username }: {
  programs.ydotool = { enable = true; };
  users.users.${username}.extraGroups = [ "ydotool" "uinput" ];
}
