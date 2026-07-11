{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Editors and IDE tools
  environment.systemPackages = with pkgs; [
    windsurf
    devin-cli
    cursor-cli
    code-cursor-fhs
  ];
}
