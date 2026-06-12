{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Editors and IDE tools
  environment.systemPackages = with pkgs; [
    neovim
    lazygit
    gdu
    bottom
    zed-editor
    vscode
    antigravity-fhs
  ];
}
