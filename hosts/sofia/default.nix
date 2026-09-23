{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  imports = [
    ../../modules/core/snapshots.nix
    ../../modules/desktop/cosmic-greeter.nix
    ../../modules/desktop/cosmic.nix
    ../../modules/desktop/default.nix
    ../../modules/virtualisation/kvm-amd.nix
  ];

   boot.loader.systemd-boot.enable = lib.mkForce false;

  sops.secrets.smb-password = { };

  services.smb = {
    enable = true;
    passwordFile = config.sops.secrets.smb-password.path;
  };

  services.cockpit = {
    enable = true;
    "allowed-origins" = [ "https://${hostname}:9090" ];
  };


  system.host = hostname;
}
