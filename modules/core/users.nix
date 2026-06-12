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
      "storage"
      "uinput"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      zsh
    ];
  };
}
