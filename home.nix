# ============================================================================
# Home Manager Configuration for stephan
#
# This file is the main entry point for your Home Manager setup.
# It imports other modules (like zsh.nix) and defines global settings,
# packages, and programs to be managed in your user environment.
#
# FILE STRUCTURE OVERVIEW:
#   home.nix      - Main configuration, imports modules, sets up packages, etc.
#   zsh.nix       - Zsh shell configuration (imported below)
#
# For more info, see: https://nix-community.github.io/home-manager/
# ============================================================================

{ config, pkgs, ... }:

{
  # --------------------------------------------------------------------------
  # Module Imports
  # --------------------------------------------------------------------------
  # Import additional configuration modules. Each module can configure a specific
  # aspect of your environment (e.g., zsh, neovim, etc.).
  imports = [
    ./zsh.nix # Zsh shell configuration (see zsh.nix)
    # Add more modules here as needed
  ];

  # --------------------------------------------------------------------------
  # Home Manager Options
  # --------------------------------------------------------------------------
  # Enable Home Manager to manage itself and set up auto-expiration for old
  # generations. This helps keep your configuration clean and up-to-date.
  # Note: This is optional and can be disabled if you prefer to manage
  # generations manually.
  services.home-manager.autoExpire.enable = true;

  # --------------------------------------------------------------------------
  # Nixpkgs Configuration
  # --------------------------------------------------------------------------
  # Allow unfree packages (e.g., proprietary software like Google Chrome).
  # Also enables zsh program support in nixpkgs.
  nixpkgs = {
    config = {
      allowUnfree = true;
      programs.zsh.enabled = true;
    };
  };

  # --------------------------------------------------------------------------
  # nixGL (OpenGL Wrapper) Configuration
  # --------------------------------------------------------------------------
  # These options help run graphical programs with the correct OpenGL drivers
  # on non-NixOS systems. Only needed if you use GPU-accelerated apps via Nix.
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "mesaPrime";
  nixGL.installScripts = [
    "mesa"
    "mesaPrime"
  ];
  nixGL.vulkan.enable = true;

  # --------------------------------------------------------------------------
  # XDG and Linux Target Settings
  # --------------------------------------------------------------------------
  # Enable support for generic Linux and XDG (desktop integration) features.
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  # --------------------------------------------------------------------------
  # (Optional) Activation Hooks
  # --------------------------------------------------------------------------
  # You can run custom commands after activating your configuration.
  # Example: update the desktop database after installing new apps.
  # home.activation = {
  #   linkDesktopApplications = {
  #     after = [ "writeBoundary" "createXdgUserDirectories" ];
  #     before = [ ];
  #     data = "/usr/bin/update-desktop-database";
  #   };
  # };

  # --------------------------------------------------------------------------
  # User Information
  # --------------------------------------------------------------------------
  # Set your username and home directory. Used by other modules.
  home.username = "stephan";
  home.homeDirectory = "/home/stephan";

  # --------------------------------------------------------------------------
  # Cursor Theme
  # --------------------------------------------------------------------------
  # Configure the mouse cursor theme for GTK applications.
  # ref: https://github.com/ful1e5/bibata
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 22;
  };

  # --------------------------------------------------------------------------
  # Home Manager State Version
  # --------------------------------------------------------------------------
  # This value should match the Home Manager release you started with.
  # Only change after reading the release notes!
  home.stateVersion = "24.11";

  # --------------------------------------------------------------------------
  # Packages
  # --------------------------------------------------------------------------
  # List of packages to be installed in your user environment.
  # You can add, remove, or comment out packages as needed.
  home.packages = [
    # Miscellaneous tools
    pkgs.nixfmt-rfc-style

    # Fonts
    pkgs.fira-code
    pkgs.powerline-fonts
    pkgs.roboto
    pkgs.noto-fonts

    # Terminal emulator
    pkgs.alacritty

    # System tools
    pkgs.tldr
    pkgs.powertop
    pkgs.btop-rocm # btop with ROCm support for AMD GPUs
    pkgs.fastfetch
    pkgs.stress
    pkgs.websocat
    pkgs.gh

    # Conferencing
    pkgs.zoom

    # Security tools
    # pkgs.yubikey-manager-qt  # Deprecated after NixOS 25.05
    pkgs.yubioath-flutter

    # Browsers
    pkgs.google-chrome

    # Media players and editors (OpenGL wrapped)
    pkgs.spotify
    (config.lib.nixGL.wrap pkgs.vlc)
    (config.lib.nixGL.wrap pkgs.darktable)
    (config.lib.nixGL.wrap pkgs.drawing)
    (config.lib.nixGL.wrap pkgs.gimp3)
    (config.lib.nixGL.wrap pkgs.krita)
    (config.lib.nixGL.wrap pkgs.inkscape)

    # Video tools
    pkgs.peek
    # pkgs.obs-studio  # See obs-studio module below
    (config.lib.nixGL.wrap pkgs.kdePackages.kdenlive)

    # Messengers
    pkgs.signal-desktop
    pkgs.discord
    pkgs.ferdium

    # Virtualization
    pkgs.virtualbox
    # pkgs.vagrant
    # pkgs.snap
    # pkgs.apparmor
    pkgs.docker
    # pkgs.docker-compose
    # pkgs.kompose
    pkgs.podman
    pkgs.podman-tui
    pkgs.podman-desktop

    # Development tools
    # pkgs.vscode
    # See below for VSCode Insiders example
    # (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #   src = (builtins.fetchTarball {
    #     url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #     sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    #   });
    #   version = "latest";
    #   buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    # });
  ];

  # --------------------------------------------------------------------------
  # Dotfiles and Custom Files
  # --------------------------------------------------------------------------
  # Manage your dotfiles or custom config files here.
  home.file = {
    # Example: link a custom .screenrc file
    # ".screenrc".source = dotfiles/screenrc;
    # Example: set content of gradle.properties
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # --------------------------------------------------------------------------
  # Environment Variables
  # --------------------------------------------------------------------------
  # Set environment variables for your user session here.
  home.sessionVariables = {
    # Example: set default editor
    # EDITOR = "emacs";
  };

  # --------------------------------------------------------------------------
  # Program and Service Modules
  # --------------------------------------------------------------------------
  # Enable and configure programs managed by Home Manager.
  programs.home-manager.enable = true; # Allow Home Manager to manage itself
  programs.nh.enable = true; # Enable nh (Nix Home) utility
  programs.vscode.enable = true; # Enable Visual Studio Code
  programs.firefox.enable = true; # Enable Firefox browser

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Stephan Koglin-Fischer";
    userEmail = "stephan.koglin-fischer@funzt.dev";
  };

  programs.direnv.enable = true; # Enable direnv for project-specific envs

  # OBS Studio (video recording/streaming) with OpenGL wrapper
  programs.obs-studio = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.obs-studio;
  };
}
