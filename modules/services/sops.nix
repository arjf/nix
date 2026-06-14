{ config, lib, pkgs, inputs, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops.defaultSopsFile = ../../secrets.yaml;
}
