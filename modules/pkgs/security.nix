{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Security
  programs.gnupg.agent.enable = true;

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry-curses
    bitwarden-desktop
    bitwarden-cli
    keepassxc
    keybase-gui
    keybase
    kbfs
  ];
}
