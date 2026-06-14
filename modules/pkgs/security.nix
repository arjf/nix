{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Security
  environment.systemPackages = with pkgs; [
    gnupg
    bitwarden-cli
    keepassxc
    keybase-gui
    keybase
    kbfs
  ];
}
