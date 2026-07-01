{ config, lib, pkgs, inputs, ... }:
{
  imports = [ inputs.lazyvim-nix.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;

    extras = {
      lang.nix.enable = true;
      lang.go.enable = true;
      lang.rust.enable = true;
      lang.python.enable = true;
      lang.json.enable = true;
      lang.markdown.enable = true;
      lang.toml.enable = true;
      lang.yaml.enable = true;
    };

    extraPackages = with pkgs; [
      nixd
      alejandra
    ];
  };
}
