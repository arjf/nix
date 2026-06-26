{ config, lib, pkgs, ... }:
{
  imports = [
    ./tailscale.nix
  ];

  services.cockpit = lib.mkDefault {
    enable = true;
    openFirewall = true;
    settings = {
      WebService = {
        LoginTo = false;
      };
    };
  };

  services.tailscale.enable = lib.mkForce true;
}
