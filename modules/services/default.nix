{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./tailscale.nix
    ./flatpak.nix
    ./kdeconnect.nix
    ./sops.nix
    ./ssh.nix
    ./sunshine.nix
    ./cockpit.nix
    ./smb.nix
  ];

  services.printing.enable = lib.mkDefault true;


  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = lib.mkDefault true;
}
