{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Office
  environment.systemPackages = with pkgs; [
    wpsoffice
    onlyoffice-desktopeditors
    libreoffice-qt
    obsidian
  ];
}
