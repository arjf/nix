{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Node/JavaScript development
  environment.systemPackages = with pkgs; [
    nodejs_latest
    comma
  ];
}
