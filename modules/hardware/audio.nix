{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.kernelModules = [ "snd-aloop" ];

  security.rtkit.enable = lib.mkDefault true;

  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault true;
  };

  environment.systemPackages = with pkgs; [
    sof-firmware
    pavucontrol
  ];
}
