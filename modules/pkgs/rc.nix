{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Remote desktop / remote control
  environment.systemPackages = with pkgs; [
    deskflow
    remmina
    kdePackages.krdc
    droidcam
    moonlight-qt
    parsec-bin
  ];
}
