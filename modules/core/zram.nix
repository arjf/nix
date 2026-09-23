{
  ...
}:
{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  systemd.oomd.enable = true;
}
