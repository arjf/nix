{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Social & Messaging
  environment.systemPackages = with pkgs; [
    # discord
    discord-rpc
    discordo
    vesktop
    materialgram
  ];
}
