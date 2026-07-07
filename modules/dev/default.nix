{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Development tools
  imports = [
    ./python.nix
    ./go.nix
    ./rust.nix
    ./nix.nix
    ./c.nix
    ./node.nix
    ./editors.nix
    ./gen-tools.nix
    ./vcs.nix
    ./aws.nix
    ./web-tools.nix
  ];

  environment.systemPackages = with pkgs; [
    javaPackages.compiler.temurin-bin.jdk-25
    qtscrcpy
    scrcpy
    distrobox
  ];
}
