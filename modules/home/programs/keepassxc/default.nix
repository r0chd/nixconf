{ lib, config, ... }:
let
  cfg = config.programs.keepassxc;
in
{
  # TODO: add more integrations
  options.programs.keepassxc.browser-integration = {
    firefox.enable = lib.mkEnableOption "firefox";
  };

  config = lib.mkIf cfg.enable {
    programs.keepassxc.settings = {
      General.ConfigVersion = 2;
      Browser = {
        Enabled = true;
        CustomProxyLocation = "";
      };
      KeeShare = {
        Active = "<?xml version=\"1.0\"?><KeeShare><Active/></KeeShare>\n";
        Own = "<?xml version=\"1.0\"?><KeeShare><PrivateKey>MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCdNRdGQREpHaeJ0AfsCLI3bq8scuHHWiYFJUaPUMRsVKltjMEGLIfq5F6J+8LcA/nxIODlqAc10njUMNgawQcicsCzD+1WHqq0IPlJjNq7xOUPHcebjeS8LHpl5Q+7c3+kbO/rH8BtOFJM6fphJBBl2uhd1qyG4PSqklh/7MDYm5GwizBco00wkKPlL2CuwaTrZHnPvBj7ef7XuTeXBGujI9lOEXBSsX0JycQCGC0VMps9V8E28KPTASYdQ1xfdgruQ1WPpQh3fvKmcLfsalhaL65eR0j5sPX9njv41LGdyOhc4vFJyftFQ8bkmU2vTJb2blF+zv2LwujICyUFKmXBAgMBAAECggEAMBANvBRjjzr6QFeCPIcSGYF0+/Vpkr28dwFE98b9LpOZsxz/3IfbzBQi1TPMCOEMVsyzBXOgNLPS7ii6wT83k7AauwQJDzXUAbs9C+AM9bBGSZ9UqfmxL1i32RQ1gZ1XrmkB1tQ/zASWoN4+Btn0S3eoaBwcZiY7lzSj6wRylyZKKp2u6XRg+DrWh4EtJAMwrm5XL1ZTgoqm1dpftJ9PQHD9K7DG4OUqw8mOUAn+jKkhrgaFlJKlydvPwvJJogKkC2oWPyJuElpYySoUbPi3m8hC8uC5wF4s2G6c2zE1KZ0Rs8NklI/8pYS9vlboFZQhR9/n4x9J1boiTpF0070PUwKBgQDNWo5GMduM0EnSAtanSfujyLJ3cqQpYYN1Os1OcYYai3bwvDXmBpYWdZEMdJx1zMsPl8q5IEPVlRokyWRVipfq+jMCZfMFTA96TTsB/OGuEqTSz+VxttH1LC7odiW4RF/waV9P0YG3MMBKh5zUwe87IP7X8k6Wn/mhCNCdT5JEjwKBgQDD+raXbG323GEHJVG/C3+gxA7k7IScJvblmUB/fV8Kgskhd+pKPt6rzBilcMUnunqQzNFFP9UKipFMM7sXXFkebQTZbiGjvk+SRA2nljkXSKLwUQa90LS8NlvBSkyWys54CIFLa2IkdtNCksFFyEcSVFTBYqfbYv47mAHapY34rwKBgELWraY1RiOQC+b6G4m5r9kAUu5D9yCs54+5gud8VczABgeXCugCzskinQJz1hUVgiZiHo6g7NNQw4CjuC+Le6T0qLOoITBhMEx7ZLBh8captNIU7rZTbgUhy2bIRcCzKJLkiSw+obzRdlULzMUHFmmldK0u5dtq2GJMrzH0m0QLAoGBAIJo4PveQUZV25L/uGfiZOk7zZVz9cJbA0xBMHQlnwrFgMVuoE8LiuzTAUuFwQvwwQJ96HumQEOldY45ljOzVfIzJVjyOhxV1WlFM7ji89aUlShJIq1IphvgKCp1IIXvKnkhX7gqGsKc93ODaGzhGroNt+B/n6cTNo29Vu6B3/ktAoGBALiwy/EVAjm6I3wmmDT/ht1bijTqlvs+bPCLGU1QLdQ6LSpeFCsLwOC1A/s6AONDj62K5Iho51J4Uftdxjx/gvw8MRV1qn7Vz2p6aVR8iyTDXJ8LUnFZonPnhFphD2k8STKyjKJE30twX8dhsoREdRY6MHy62ubC2gmyREVbhDfx</PrivateKey><PublicKey><Signer>unixpariah</Signer><Key>MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCdNRdGQREpHaeJ0AfsCLI3bq8scuHHWiYFJUaPUMRsVKltjMEGLIfq5F6J+8LcA/nxIODlqAc10njUMNgawQcicsCzD+1WHqq0IPlJjNq7xOUPHcebjeS8LHpl5Q+7c3+kbO/rH8BtOFJM6fphJBBl2uhd1qyG4PSqklh/7MDYm5GwizBco00wkKPlL2CuwaTrZHnPvBj7ef7XuTeXBGujI9lOEXBSsX0JycQCGC0VMps9V8E28KPTASYdQ1xfdgruQ1WPpQh3fvKmcLfsalhaL65eR0j5sPX9njv41LGdyOhc4vFJyftFQ8bkmU2vTJb2blF+zv2LwujICyUFKmXBAgMBAAECggEAMBANvBRjjzr6QFeCPIcSGYF0+/Vpkr28dwFE98b9LpOZsxz/3IfbzBQi1TPMCOEMVsyzBXOgNLPS7ii6wT83k7AauwQJDzXUAbs9C+AM9bBGSZ9UqfmxL1i32RQ1gZ1XrmkB1tQ/zASWoN4+Btn0S3eoaBwcZiY7lzSj6wRylyZKKp2u6XRg+DrWh4EtJAMwrm5XL1ZTgoqm1dpftJ9PQHD9K7DG4OUqw8mOUAn+jKkhrgaFlJKlydvPwvJJogKkC2oWPyJuElpYySoUbPi3m8hC8uC5wF4s2G6c2zE1KZ0Rs8NklI/8pYS9vlboFZQhR9/n4x9J1boiTpF0070PUwKBgQDNWo5GMduM0EnSAtanSfujyLJ3cqQpYYN1Os1OcYYai3bwvDXmBpYWdZEMdJx1zMsPl8q5IEPVlRokyWRVipfq+jMCZfMFTA96TTsB/OGuEqTSz+VxttH1LC7odiW4RF/waV9P0YG3MMBKh5zUwe87IP7X8k6Wn/mhCNCdT5JEjwKBgQDD+raXbG323GEHJVG/C3+gxA7k7IScJvblmUB/fV8Kgskhd+pKPt6rzBilcMUnunqQzNFFP9UKipFMM7sXXFkebQTZbiGjvk+SRA2nljkXSKLwUQa90LS8NlvBSkyWys54CIFLa2IkdtNCksFFyEcSVFTBYqfbYv47mAHapY34rwKBgELWraY1RiOQC+b6G4m5r9kAUu5D9yCs54+5gud8VczABgeXCugCzskinQJz1hUVgiZiHo6g7NNQw4CjuC+Le6T0qLOoITBhMEx7ZLBh8captNIU7rZTbgUhy2bIRcCzKJLkiSw+obzRdlULzMUHFmmldK0u5dtq2GJMrzH0m0QLAoGBAIJo4PveQUZV25L/uGfiZOk7zZVz9cJbA0xBMHQlnwrFgMVuoE8LiuzTAUuFwQvwwQJ96HumQEOldY45ljOzVfIzJVjyOhxV1WlFM7ji89aUlShJIq1IphvgKCp1IIXvKnkhX7gqGsKc93ODaGzhGroNt+B/n6cTNo29Vu6B3/ktAoGBALiwy/EVAjm6I3wmmDT/ht1bijTqlvs+bPCLGU1QLdQ6LSpeFCsLwOC1A/s6AONDj62K5Iho51J4Uftdxjx/gvw8MRV1qn7Vz2p6aVR8iyTDXJ8LUnFZonPnhFphD2k8STKyjKJE30twX8dhsoREdRY6MHy62ubC2gmyREVbhDfx</Key></PublicKey></KeeShare>\n";
        QuietSuccess = true;
      };
      PasswordGenerator = {
        AdditionalChars = "";
        ExcludedChars = "";
      };
      GUI = {
        ShowTrayIcon = true;
        LaunchAtStartup = true;
        MinimizeOnClose = true;
        MinimizeOnStartup = true;
      };
      SSHAgent.Enabled = true;
    };

    home.file = {
      ".mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json" =
        lib.mkIf cfg.browser-integration.firefox.enable
          {
            text = ''
              {
                  "allowed_extensions": [
                      "keepassxc-browser@keepassxc.org"
                  ],
                  "description": "KeePassXC integration with native messaging support",
                  "name": "org.keepassxc.keepassxc_browser",
                  "path": "${cfg.package}/bin/keepassxc-proxy",
                  "type": "stdio"
              }
            '';
          };
    };
  };
}
