{ config, pkgs, ... }:

{
  imports = [
    ./zsh.nix
    # Other module imports
  ];

  # ref: https://fnordig.de/til/nix/home-manager-allow-unfree.html
  nixpkgs = {
    config = {
      allowUnfree = true;

      programs.zsh.enabled = true;
    };
  };

  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [
    "mesa"
    "nvidiaPrime"
  ];
  nixGL.vulkan.enable = true;

  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  # The home.activation option allows you to run arbitrary code when activating
  # your configuration. This is useful for running commands that need to be running
  # after the configuration is activated. For example, you might want to run
  # 'update-desktop-database' to update the desktop database after installing
  # new desktop files.
  # home.activation = {
  #   linkDesktopApplications = {
  #     after = [ "writeBoundary" "createXdgUserDirectories" ];
  #     before = [ ];
  #     data = "/usr/bin/update-desktop-database";
  #   };
  # };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "stephan";
  home.homeDirectory = "/home/stephan";

  # The cursor theme is used by GTK applications. The default cursor theme is
  # "DMZ-Black". You can find a list of available cursor themes in
  # /usr/share/icons. You can also install additional cursor themes using
  # home.packages.
  # ref: https://github.com/ful1e5/bibata
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 22;
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Misc
    pkgs.nixfmt-rfc-style

    # Fonts
    pkgs.fira-code
    pkgs.powerline-fonts
    pkgs.roboto
    pkgs.noto-fonts

    # Shells
    # pkgs.bash
    pkgs.zsh

    # Terminal emulator
    pkgs.alacritty

    # System tools
    pkgs.tldr
    pkgs.powertop
    pkgs.btop-rocm # btop with ROCm support to monitor AMD GPUs
    pkgs.fastfetch
    pkgs.stress
    pkgs.websocat
    pkgs.gh

    # Conferencing
    pkgs.zoom

    # Tools
    # pkgs.yubikey-manager-qt # yubikey-manager-qt will be dropped after NixOS 25.05
    pkgs.yubioath-flutter

    # Browsers
    pkgs.google-chrome
    pkgs.firefox

    # Media
    pkgs.spotify
    # Media - With OpenGL support
    (config.lib.nixGL.wrap pkgs.vlc)
    (config.lib.nixGL.wrap pkgs.darktable)
    (config.lib.nixGL.wrap pkgs.drawing)
    (config.lib.nixGL.wrap pkgs.gimp3)
    (config.lib.nixGL.wrap pkgs.krita)
    (config.lib.nixGL.wrap pkgs.inkscape)

    # Video
    pkgs.peek
    # pkgs.obs-studio # Is setup using the obs-studio module
    (config.lib.nixGL.wrap pkgs.kdePackages.kdenlive)

    # Messangers
    pkgs.signal-desktop
    pkgs.discord
    pkgs.ferdium

    # Virtualisation
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

    # Development
    # pkgs.vscode
    # vscode insiders - ref: https://nixos.wiki/wiki/Visual_Studio_Code#Insiders_Build
    # (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
    #   src = (builtins.fetchTarball {
    #     url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
    #     sha256 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
    #   });
    #   version = "latest";

    #   buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
    # });
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/stephan/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.starship.enable = true;

  programs.nh.enable= true;
  programs.vscode.enable = true;

  programs.git = {
    enable = true;
    userName = "Stephan Koglin-Fischer";
    userEmail = "stephan.koglin-fischer@funzt.dev";
  };

  programs.direnv.enable = true;

  programs.obs-studio = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.obs-studio;
  };
}
