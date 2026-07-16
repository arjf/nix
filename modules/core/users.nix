{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.jo = {
    isNormalUser = true;
    description = "jo";
    extraGroups = [
      "wheel"
      "input"
      "storage"
      "uinput"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      zsh
    ];
  };
}
