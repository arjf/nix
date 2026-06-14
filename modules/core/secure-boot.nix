{ config, lib, pkgs, inputs, ... }: {
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      includeMicrosoftKeys = true;
    };
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce true;

  environment.systemPackages = with pkgs; [ sbctl ];
}
