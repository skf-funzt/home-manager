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
{
  config,
  pkgs,
  nixgl,
  ...
}: {
  # --------------------------------------------------------------------------
  # Module Imports
  # --------------------------------------------------------------------------
  # Import additional configuration modules. Each module can configure a specific
  # aspect of your environment (e.g., zsh, neovim, etc.).
  imports = [
    ./zsh.nix # Zsh shell configuration (see zsh.nix)
    # currently not working
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

      # Add myself to the trusted users list for Nixpkgs.
      # extra-substituters = "https://devenv.cachix.org";
      # extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    };
  };

  # --------------------------------------------------------------------------
  # nixGL (OpenGL Wrapper) Configuration
  # --------------------------------------------------------------------------
  # These options help run graphical programs with the correct OpenGL drivers
  # on non-NixOS systems. Only needed if you use GPU-accelerated apps via Nix.
  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  # nixGL.offloadWrapper = "mesaPrime";
  nixGL.installScripts = [
    "mesa"
    # "mesaPrime"
  ];
  # ! This setting breaks Gnome 46 completely for X and Wayland
  # nixGL.vulkan.enable = true;

  # --------------------------------------------------------------------------
  # XDG and Linux Target Settings
  # --------------------------------------------------------------------------
  # Enable support for generic Linux and XDG (desktop integration) features.
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];

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

  # # --------------------------------------------------------------------------
  # # Cursor Theme
  # # --------------------------------------------------------------------------
  # # Configure the mouse cursor theme for GTK applications.
  # # ref: https://github.com/ful1e5/bibata
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 22;
  };

  # # --------------------------------------------------------------------------
  # # GTK Configuration
  # # --------------------------------------------------------------------------

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus-Dark";
  };

  # --------------------------------------------------------------------------
  # Stylix Configuration
  # --------------------------------------------------------------------------
  stylix.enable = false; # Enable Stylix for cursor theme management
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/eighties.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://zebreus.github.io/all-gnome-backgrounds/images/keys-d-65e33e56cb91fc3b79d997399d2b660fbad42c84.webp";
    hash = "sha256-2cGDxBwObirDJQ4bizAZPqak7xm0kuSaFL0QRw7uDlc=";
  };
  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.size = 22;
  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    light = "Papirus-Light";
    dark = "Papirus-Dark";
  };

  stylix.polarity = "dark";

  stylix.fonts = {
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };

    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };

    monospace = {
      package = pkgs.hackgen-nf-font;
      name = "Hack Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };

  # stylix.targets.firefox.profileNames = [ "default" ];

  # --------------------------------------------------------------------------
  # Home Manager State Version
  # --------------------------------------------------------------------------
  # This value should match the Home Manager release you started with.
  # Only change after reading the release notes!
  home.stateVersion = "25.05";

  # --------------------------------------------------------------------------
  # Packages
  # --------------------------------------------------------------------------
  # List of packages to be installed in your user environment.
  # You can add, remove, or comment out packages as needed.
  home.packages = [
    # Miscellaneous tools
    pkgs.nixfmt-rfc-style
    pkgs.nil
    pkgs.nixd
    pkgs.alejandra
    pkgs.devenv

    # Fonts
    pkgs.fira-code
    pkgs.nerd-fonts.fira-code
    pkgs.hackgen-nf-font
    pkgs.powerline-fonts
    pkgs.roboto
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji

    # Icons
    pkgs.papirus-icon-theme

    # Terminal emulator
    (config.lib.nixGL.wrap pkgs.alacritty)

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
    # (config.lib.nixGL.wrap pkgs.google-chrome) # Chrome works only with the patched version of nixGL from https://github.com/nix-community/nixGL/pull/190
    (config.lib.nixGL.wrap pkgs.firefox)

    # Media players and editors (OpenGL wrapped)
    pkgs.spotify
    (config.lib.nixGL.wrap pkgs.vlc)
    (config.lib.nixGL.wrap pkgs.darktable)
    (config.lib.nixGL.wrap pkgs.drawing)
    (config.lib.nixGL.wrap pkgs.gimp3)
    (config.lib.nixGL.wrap pkgs.krita)
    (config.lib.nixGL.wrap pkgs.inkscape)
    (config.lib.nixGL.wrap pkgs.blender)
    (config.lib.nixGL.wrap pkgs.obs-studio)

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
    # pkgs.docker # This is not supported on non-nixos systems and should be done using the systems package manager - ref: https://nixos.wiki/wiki/Docker#:~:text=for%20further%20options-,Running%20the%20docker%20daemon%20from%20nix%2Dthe%2Dpackage%2Dmanager%20%2D%20not%20NixOS,-This%20is%20not
    # pkgs.docker-compose
    # pkgs.kompose
    # pkgs.podman # This is not supported on non-nixos systems and should be done using the systems package manager - ref: https://nixos.wiki/wiki/Docker#:~:text=for%20further%20options-,Running%20the%20docker%20daemon%20from%20nix%2Dthe%2Dpackage%2Dmanager%20%2D%20not%20NixOS,-This%20is%20not
    pkgs.podman-tui
    pkgs.podman-desktop

    # Development tools
    pkgs.vscode
    # See below for VSCode Insiders example
    # (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #   src = (builtins.fetchTarball {
    #     url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #     sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    #   });
    #   version = "latest";
    #   buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    # });

    # Key Tools
    pkgs.infisical

    # Management Tools
    pkgs.logseq
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
  # programs.vscode.enable = true; # Enable Visual Studio Code

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Stephan Koglin-Fischer";
    userEmail = "stephan.koglin-fischer@funzt.dev";
  };
  # programs.gh.enable = true;
  # programs.gh-acy.enable = true; # Does not exists
  # programs.gh-dash.enable = true;
  programs.gitui.enable = true;

  programs.direnv.enable = true; # Enable direnv for project-specific envs

  programs.chromium = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.chromium; # Use the Chromium browser package
  }; # Enable Chromium browser
}
