{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #./sddm.nix
    #./plasma.nix
    ./hw-accel.nix
  ];

  services.printing.enable = lib.mkDefault true;

  services.gvfs.enable = lib.mkDefault true;
  services.udisks2.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  services.xserver.enable = lib.mkDefault true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.xserver.videoDrivers = lib.mkDefault [
    "modesetting"
  ];
}
