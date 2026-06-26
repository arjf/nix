{ config, lib, pkgs, ... }:
{
  imports = [
    ./tailscale.nix
  ];

  services.cockpit = lib.mkDefault {
    enable = true;
    openFirewall = false;
    settings = {
      WebService = {
        Origins = "https://localhost:9090";
        LoginTo = false;
      };
    };
  };

  services.tailscale.enable = lib.mkForce true;

  systemd.sockets.cockpit.socketConfig.BindToDevice = lib.mkDefault "tailscale0";
}
