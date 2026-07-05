{ config, lib, pkgs, inputs, ... }: {
  imports = [
    inputs.niri.nixosModules.niri
    ./wayland-tooling.nix
  ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];

  programs.niri = {
    enable = lib.mkDefault true;
    package = pkgs.niri-unstable;
  };

  environment.systemPackages = with pkgs; [
    inputs.niri-scratchpad.packages.${pkgs.system}.default
  ];
}
