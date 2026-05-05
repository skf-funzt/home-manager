# ============================================================================
# Home Manager Configuration for Raspberry Pi 3B
#
# Lightweight user environment — shares shell (zsh.nix) and editor
# (nixvim.nix) with the workstation, but skips desktop-heavy packages,
# nixGL, stylix, and GPU-specific tools.
#
# Usage:  home-manager switch --flake ~/.config/home-manager#pi
# ============================================================================
{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  imports = [
    ./zsh.nix
    ./nixvim.nix
    ./opencode-custom.nix
  ];

  home.username = "pi";
  home.homeDirectory = "/home/pi";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Stephan Koglin-Fischer";
      email = "stephan.koglin-fischer@funzt.dev";
    };
  };

  programs.direnv.enable = true;

  programs.foot = {
    enable = true;
    settings.main.font = "monospace:size=14";
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "foot";
      output."*" = {
        scale = "1";
      };
      input."type:touch" = {
        tap = "enabled";
      };
    };
  };

  home.packages =
    (with pkgs; [
      htop
      fastfetch
      nixfmt-rfc-style
      nil
      nerd-fonts.fira-code
      hackgen-nf-font
    ])
    ++ [
      pkgs-unstable.devenv
    ];
}
