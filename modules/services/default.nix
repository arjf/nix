{ config, lib, pkgs, ... }: {
  imports = [
    ./tailscale.nix
    ./flatpak.nix
    ./cuda.nix
    ./kdeconnect.nix
    ./throttled.nix
  ];

  services.printing.enable = lib.mkDefault true;

  services.openssh.enable = lib.mkDefault true;
  networking.firewall.allowedTCPPorts = lib.mkDefault [ 22 ];

  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = lib.mkDefault true;
}
