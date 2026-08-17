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
    (moonlight-qt.override {
      ffmpeg = ffmpeg_8;
    })
    parsec-bin
  ];
}
