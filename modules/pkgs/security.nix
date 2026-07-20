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
    # bitwarden-desktop # waiting on upstream fix on electron ver
    bitwarden-cli
    keepassxc
    keybase-gui
    keybase
    kbfs
  ];
}
