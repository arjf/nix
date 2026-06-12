{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./nix-ld.nix
    ./obs-studio.nix
    ./zsh.nix
    ./cmdline-tools.nix
    ./term-emus.nix
    ./security.nix
    ./games.nix
    ./socials.nix
    ./office.nix
    ./browsers.nix
    ./media.nix
    ./rc.nix
  ];

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    dosfstools
    android-tools
  ];
}
