{ config, lib, pkgs, inputs, ... }:
{
  services.openssh = lib.mkDefault {
    enable = true;
    openFirewall = true;
    ports = [ 22 ];
    settings = {
      AddressFamily = "inet";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      X11Forwarding = true;
      MaxAuthTries = 6;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";

    };
  };

  networking.firewall.allowedTCPPorts = lib.mkDefault [ 22 ];

}
