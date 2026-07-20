{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    openvino
    openvino-genai
    openvino-tokenizers
  ];
}
