{username, ...}: {
  users.users."${username}".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCf4yubZL6TNB7e5Z59Vx4uMa2Qt4dVy/CztFXZWomU5nfpXFGelUNMj/hOV6RRfMCoo2mVZ6wW3Uf6yZq90KMzfzbF9l833K2hdVxZrUB4F2m9gukx5KJdDQY6DCfBskhbWVnsVEKdqdxqKMmCTYf+YXDcfoOOZ2jeiTAOftWezvYPs1DRGIEXdPBM55DBD/zviGMo7e5LDcgsy6WAWcZT54STjiQcgTtBQmNWXdrbHoELC55oUjNekkOJFKde+Iyyb7WUlIquapG87oUHRI6hRIfwsQOMJ8wmIxw2WFx1gRGTIMe/V9PpzIHghV1yIw7b7J1taacFVoa1RypAzGjyoKEmXjKk4WTcL6sEfaH4nLmBRMrHrE5y4DxleB9Maj00WyfTqkUaskN9neN2yGGC9XQtLjfbka0ugjgHfn+dB42rI5E6cSOEaSNVHxkZvVA9dsKLTvU6pQKzNi9Pb9bYQuIFaK99EbIdNqg7oYSSdcug4P3ApteyWGKtKyX8lOc= unixpariah@laptop"
  ];
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}
