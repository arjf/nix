{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.tailscale.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    tailscale
  ];
}
