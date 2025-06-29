{ ... }:
{
  environment.etc = {
    "pam.d/sudo".text = ''
      #%PAM-1.0

      # Set up user limits from /etc/security/limits.conf.
      session    required   pam_limits.so

      session    required   pam_env.so readenv=1 user_readenv=0
      session    required   pam_env.so readenv=1 envfile=/etc/default/locale user_readenv=0
      auth       sufficient pam_u2f.so

      @include common-u2f
      @include common-auth
      @include common-account
      @include common-session-noninteractive
    '';
    "pam.d/common-u2f".text = ''
      auth sufficient pam_u2f.so authfile=/etc/u2f_mappings cue
    '';
    "pam.d/pamu2f".text = ''
      auth sufficient pam_u2f.so debug
    '';
  };
}
