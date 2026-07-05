{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    waybar
    mako
    rofi
  ];
}
