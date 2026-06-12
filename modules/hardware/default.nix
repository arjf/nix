{ config, lib, pkgs, ... }: {
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./graphics.nix
    ./wifi.nix
    ./ec.nix
    ./xone.nix
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.uinput.enable = lib.mkDefault true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
