{
  config,
  lib,
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    awscli2
    aws-iam-authenticator
    aws-sso-cli
    aws-vault
  ];
}
