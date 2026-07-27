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
      "video"
      "render"
      "lpadmin"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      zsh
    ];
  };
}
