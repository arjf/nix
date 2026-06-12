{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Social & Messaging
  environment.systemPackages = with pkgs; [
    vesktop
    materialgram
  ];
}
