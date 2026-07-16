{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./tailscale.nix
  ];

  services.cockpit = lib.mkDefault {
    enable = true;
    openFirewall = false;
    settings = {
      WebService = {
        LoginTo = false;
      };
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 9090 ];

  services.tailscale.enable = lib.mkForce true;
}
