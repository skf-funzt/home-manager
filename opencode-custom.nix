{ config, pkgs, inputs, ... }:

{
  home.packages = [
    inputs.opencode-pr.packages.${pkgs.system}.default
  ];
}