{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
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
    pkgs.opencode

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

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

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
