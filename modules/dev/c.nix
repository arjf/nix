{
  config,
  lib,
  pkgs,
  ...
}:
{
  # C/C++ development
  environment.systemPackages = with pkgs; [
    gcc
    gdb
    cmake
    pkg-config
    gnumake
    autoconf
    openssl
    openssl.dev
    zlib
    zlib.dev
  ];
}
