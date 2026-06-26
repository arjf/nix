{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types mkForce;
  cfg = config.services.smb;
in
{
  imports = [
    ./tailscale.nix
  ];

  options.services.smb = {
    enable = mkEnableOption "SMB server bound to tailscale";

    userName = mkOption {
      type = types.str;
      default = "jo";
      description = "Samba user name for authentication";
    };

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a file containing the samba password.
        If set, the password will be applied via smbpasswd on activation.
        If null, the user must set it manually with `smbpasswd -a <user>`.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = mkForce true;

    services.samba = {
      enable = true;
      nmbd.enable = false;
      winbindd.enable = false;
      openFirewall = true;
      settings = {
        global = {
          "server min protocol" = "SMB3_11";
          "server max protocol" = "SMB3_11";
          security = "user";
          "passdb backend" = "tdbsam";
        };
        "${cfg.userName}" = {
          path = "/home/${cfg.userName}";
          "valid users" = cfg.userName;
          "read only" = "no";
          browseable = "yes";
          comment = "${cfg.userName}'s home directory";
        };
      };
    };

    users.users.${cfg.userName}.extraGroups = [ "samba" ];

    systemd.services.samba-password-setup = mkIf (cfg.passwordFile != null) {
      description = "Set Samba password for ${cfg.userName}";
      before = [ "samba-smbd.service" ];
      wantedBy = [ "samba.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        if ! ${pkgs.samba}/bin/pdbedit -L "${cfg.userName}" 2>/dev/null; then
          PASS=$(${pkgs.coreutils}/bin/cat "${cfg.passwordFile}")
          ${pkgs.coreutils}/bin/printf "%s\n%s\n" "$PASS" "$PASS" | \
            ${pkgs.samba}/bin/smbpasswd -a -s "${cfg.userName}"
        fi
      '';
    };
  };
}
