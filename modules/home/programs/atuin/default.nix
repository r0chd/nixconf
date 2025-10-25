_:
{
  programs.atuin = {
    daemon.enable = true;
    settings = {
      #sync.records = true;
      #sync_frequency = "1";
      #daemon.sync_frequency = "1";
      auto_sync = true;
      #sync_address = "http://atuin.your-domain.com";
    };
  };
}
