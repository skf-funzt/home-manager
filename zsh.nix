{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zsh = {
    enable = true;

    # History settings
    history = {
      path = "${config.home.homeDirectory}/.histfile";
      size = 10000;
      save = 10000;
      ignoreDups = true;
      share = true;
      append = true;
    };

    # Shell options
    autocd = true;
    dotDir = ".config/zsh";

    # Enable zsh plugins managed by Home Manager
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    # Shell aliases
    shellAliases = {
      adhu = "~/Android/Sdk/extras/google/auto/desktop-head-unit";
      reload = "source ~/.zshrc && zsh";
    };

    # oh-my-zsh integration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "archlinux"
        "git"
        "git-extras"
        "git-flow"
        "gradle"
        "history"
        "npm"
        "yarn"
        "emoji"
        "flutter"
        "gitignore"
        "systemd"
        "colored-man-pages"
        "command-not-found"
        "zsh-interactive-cd"
      ];
    };

    # Additional external plugins
    plugins = [
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "0.34.0"; # Replace with the version you want
          sha256 = "sha256-qSobM4PRXjfsvoXY6ENqJGI9NEAaFFzlij6MPeTfT0o="; # Replace with the actual hash
        };
      }
      {
        name = "nix-zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "nix-community";
          repo = "nix-zsh-completions";
          rev = "0.5.0"; # Replace with the version you want
          sha256 = "sha256-DKvCpjAeCiUwD5l6PUW7WlEvM0cNZEOk41IiVXoh9D8="; # Replace with the actual hash
        };
      }
      {
        name = "docker-aliases";
        src = pkgs.fetchFromGitHub {
          owner = "webyneter";
          repo = "docker-aliases";
          rev = "master"; # Use specific tag/version when possible
          sha256 = "sha256-Lh+JtPYRY6GraIBnal9MqWGxhJ4+b6aowSDJkTl1wVE="; # Replace with the actual hash
        };
      }
    ];

    # Environment variables
    envExtra = ''
      # # Go configuration
      # export GOPATH=$HOME/go
      # export GOBIN=$GOPATH/bin

      # # Node.js configuration
      # export npm_config_prefix=$HOME/.node_modules

      # # Java configuration
      # export JAVA_HOME=/usr/lib/jvm/default

      # # Flutter Chrome executable path
      # export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
    '';

    # Path additions - can be done with home.sessionVariables.PATH
    initContent = ''
      # Load key binding
      bindkey -e

      # Completion settings
      zstyle ':completion:*' use-cache on

      # zstyle for oh-my-zsh
      zstyle ':omz:update' mode auto
      
      # # Support for dot command
      # export PATH=".:$PATH"

      # # Skip words with CTRL+arrow
      # bindkey '^[[1;5C' forward-word
      # bindkey '^[[1;5D' backward-word

      # # ASDF configuration
      # export PATH="${config.home.homeDirectory}/.asdf/shims:$PATH"
      # mkdir -p "${config.home.homeDirectory}/.asdf/completions"
      # if command -v asdf &> /dev/null; then
      #   asdf completion zsh > "${config.home.homeDirectory}/.asdf/completions/_asdf"
      # fi

      # # Load ASDF Java home
      # if [ -f ${config.home.homeDirectory}/.asdf/plugins/java/set-java-home.zsh ]; then
      #   source ${config.home.homeDirectory}/.asdf/plugins/java/set-java-home.zsh
      # fi

      # # Load p10k configuration
      # if [ -f ${config.home.homeDirectory}/.p10k.zsh ]; then
      #   source ${config.home.homeDirectory}/.p10k.zsh
      # fi

      # # bun completions
      # if [ -s "${config.home.homeDirectory}/.bun/_bun" ]; then
      #   source "${config.home.homeDirectory}/.bun/_bun"
      # fi

      # # tmux shell settings (these should actually be in tmux config, not zsh)
      # if [ -n "$TMUX" ]; then
      #   set -g default-command /bin/zsh
      #   set -g default-shell /bin/zsh
      # fi

      # Add a reload function to reload zsh
      function reload() {
        source ~/.zshrc && zsh
      }
    '';
  };

  # Configure Powerlevel10k if you want to keep using it
  # programs.powerlevel10k = {
  #   enable = true;
  #   # You might want to add other p10k settings here
  # };

  # Configure Starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # Configure zoxide
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Home path configuration - add all your PATH extensions here
  home.sessionPath = [
    # "$HOME/flutter/bin"
    # "$HOME/go/bin"
    # "$HOME/.node_modules/bin"
    # "$HOME/.yarn/bin"
    # "/root/.gem/ruby/2.6.0/bin"
    # "$HOME/.gem/ruby/2.6.0/bin"
    # "$HOME/.pub-cache/bin"
    # "$HOME/.config/composer/vendor/bin"
    # "$HOME/flutter/.pub-cache/bin"
    # "/opt/anaconda/bin"
    # "$HOME/Library/Android/sdk/platform-tools"
    # "$HOME/Library/Android/sdk/emulator"
    # "$HOME/Android/Sdk/platform-tools"
    # "$HOME/Android/Sdk/emulator"
    # "$JAVA_HOME/bin"
    # "$HOME/.config/Code/User/globalStorage/ms-vscode-remote.remote-containers/cli-bin"
    # "$HOME/projects/github/AnnePro2-Tools/target/release"
  ];
}
