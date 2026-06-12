{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../hardware/v4l2lo.nix
  ];

  programs.obs-studio = {
    enable = lib.mkDefault true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };
}
