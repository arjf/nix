{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Throttled daemon for managing intel CPUs
  services.throttled.enable = lib.mkDefault true;
  services.throttled.extraConfig = builtins.readFile ./throttled.conf;

  environment.systemPackages = with pkgs; [
    throttled
  ];
}
