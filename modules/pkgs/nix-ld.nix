{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nix-ld.enable = lib.mkDefault true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    glib
  ];
}
