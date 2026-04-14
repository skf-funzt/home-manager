{ config, pkgs, ... }:

{
  # Note: Use `environment.systemPackages` for NixOS.
  # If you are using Home Manager, change this to `home.packages`.
  environment.systemPackages = with pkgs; [
    (opencode.overrideAttrs (oldAttrs: {
      src = fetchFromGitHub {
        owner = "anomalyco";
        repo = "opencode";
        rev = "refs/pull/9871/head";
        # Leave the hash empty for now. Nix will complain and give you the correct one.
        hash = "";
      };
    }))
  ];
}
