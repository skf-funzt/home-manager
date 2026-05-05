{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  flakeDir = "$DEVENV_ROOT";
in
{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    # Git: version control system used for source management and CI checks.
    pkgs.git

    # opencode: project-specific CLI/tools used during development.
    # Provides helper commands used in local workflows; replace or extend
    # this with your project's preferred toolset if needed.
    # pkgs.opencode

    # GitHub Copilot CLI: provides the `copilot` binary for AI-assisted
    # coding in the terminal. Note: you must sign in (eg. `copilot auth
    # login`) to use it.
    pkgs.github-copilot-cli

    # bashInteractive: a user-friendly interactive bash with completion
    # and prompt improvements for a better shell UX while developing.
    pkgs.bashInteractive
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;
  languages.javascript.enable = true;
  languages.javascript.npm.enable = true;
  languages.javascript.bun.enable = true;

  # https://devenv.sh/processes/
  # processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  # scripts.hello.exec = ''
  #   echo hello from $GREET
  # '';

  # https://devenv.sh/basics/
  # enterShell = ''
  #   hello         # Run scripts directly
  #   git --version # Use packages
  # '';

  # ---------------------------------------------------------------------------
  # Home Manager Tasks
  # ---------------------------------------------------------------------------
  # Build and switch home-manager configurations for different GPU types.
  #
  # Available configurations (defined in flake.nix):
  #   stephan        — AMD Radeon 780M iGPU (ROCm)
  #   stephan-nvidia — NVIDIA GPU (CUDA)
  #   stephan-cpu    — CPU-only (no GPU acceleration)
  #
  # Usage:
  #   devenv tasks run hm:build          # Build AMD (default)
  #   devenv tasks run hm:switch         # Apply AMD (default)
  #   devenv tasks run hm:build:nvidia   # Build NVIDIA
  #   devenv tasks run hm:switch:nvidia  # Apply NVIDIA
  #   devenv tasks run hm:build:cpu      # Build CPU-only
  #   devenv tasks run hm:switch:cpu     # Apply CPU-only
  #   devenv tasks run hm:status         # Show current generation info
  #   devenv tasks run hm:diff           # Show what would change on switch
  # ---------------------------------------------------------------------------
  tasks = {
    # ---- AMD (default) ----
    "hm:build".exec = ''
      echo "🔨 Building home-manager config: stephan (AMD/ROCm)..."
      home-manager build --flake ${flakeDir}#stephan
      echo "✅ Build succeeded. Run 'devenv tasks run hm:switch' to apply."
    '';

    "hm:switch".exec = ''
      echo "🔄 Switching home-manager config: stephan (AMD/ROCm)..."
      home-manager switch --flake ${flakeDir}#stephan
      echo "✅ Switch complete. New session variables take effect in new shells."
    '';

    # ---- NVIDIA ----
    "hm:build:nvidia".exec = ''
      echo "🔨 Building home-manager config: stephan-nvidia (CUDA)..."
      home-manager build --flake ${flakeDir}#stephan-nvidia
      echo "✅ Build succeeded. Run 'devenv tasks run hm:switch:nvidia' to apply."
    '';

    "hm:switch:nvidia".exec = ''
      echo "🔄 Switching home-manager config: stephan-nvidia (CUDA)..."
      home-manager switch --flake ${flakeDir}#stephan-nvidia
      echo "✅ Switch complete. New session variables take effect in new shells."
    '';

    # ---- CPU-only ----
    "hm:build:cpu".exec = ''
      echo "🔨 Building home-manager config: stephan-cpu (CPU-only)..."
      home-manager build --flake ${flakeDir}#stephan-cpu
      echo "✅ Build succeeded. Run 'devenv tasks run hm:switch:cpu' to apply."
    '';

    "hm:switch:cpu".exec = ''
      echo "🔄 Switching home-manager config: stephan-cpu (CPU-only)..."
      home-manager switch --flake ${flakeDir}#stephan-cpu
      echo "✅ Switch complete. New session variables take effect in new shells."
    '';

    # ---- Status & Diff ----
    "hm:status".exec = ''
      echo "📋 Current home-manager generation:"
      home-manager generations | head -5
      echo ""
      echo "🔧 Current Ollama env vars:"
      env | grep -E "^(OLLAMA_|HSA_|GPU_MAX|ROCR_)" | sort || echo "  (none set in this shell — open a new terminal after switch)"
      echo ""
      echo "📦 Ollama binary:"
      which ollama 2>/dev/null && ollama --version || echo "  (not found in PATH)"
    '';

    "hm:diff".exec = ''
      echo "🔍 Diffing current vs new home-manager config (AMD)..."
      nix store diff-closures \
        $(home-manager generations | head -1 | awk '{print $NF}') \
        $(home-manager build --flake ${flakeDir}#stephan --print-out-paths 2>/dev/null) \
        2>/dev/null || echo "  (diff unavailable — first generation or build needed)"
    '';
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
    echo "Copilot version" && copilot --version
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
