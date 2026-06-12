{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Terminal emulators
  environment.systemPackages = with pkgs; [
    alacritty
    alacritty-theme
    kitty
  ];
}
