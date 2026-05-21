{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    handy.url = "github:cjpais/Handy";
    handy.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # khanelivim brings a newer wversion with it
    # nixvim.url = "github:nix-community/nixvim";
    # nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";

    khanelivim = {
      url = "github:khaneliman/khanelivim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Custom opencode with config reloading (path: makes it portable across machines)
    # opencode-pr.url = "path:./opencode";

    # nvf works best with and only directly supports flakes
    nvf = {
      url = "github:NotAShelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Noctalia shell
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixgl,
      stylix,
      handy,
      nixvim,
      khanelivim,
      nvf,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Shared pkgs instances (reused across all configurations)
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "electron-37.10.3"
          ];
        };
        overlays = [ nixgl.overlay ];
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [ ];
        };
      };

      # ── Raspberry Pi (aarch64, NixOS) ──────────────────────────
      pkgs-pi = import nixpkgs {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };

      pkgs-pi-unstable = import nixpkgs-unstable {
        system = "aarch64-linux";
        config.allowUnfree = true;
      };

      # Helper: create a homeManagerConfiguration with a specific GPU type.
      #
      # gpuType: "amd" | "nvidia" | "cpu"
      #   - "amd"    → ollama-rocm + HSA_OVERRIDE_GFX_VERSION + GPU_MAX_ALLOC_PERCENT
      #   - "nvidia"  → ollama-cuda
      #   - "cpu"     → plain ollama (no GPU acceleration)
      #
      # Usage: mkHome "amd"
      # Then: home-manager switch --flake .#stephan       (default, AMD)
      #       home-manager switch --flake .#stephan-nvidia
      #       home-manager switch --flake .#stephan-cpu
      mkHome =
        gpuType:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            stylix.homeModules.stylix
            nixvim.homeModules.nixvim
            nvf.homeManagerModules.default
            ./home.nix
            ./noctalia.nix
          ];
          extraSpecialArgs = {
            inherit
              inputs
              pkgs-unstable
              nixgl
              handy
              nixvim
              khanelivim
              gpuType
              ;
          };
        };
    in
    {
      homeConfigurations = {
        # Default: AMD Radeon 780M iGPU (Framework Laptop 13, gfx1103)
        stephan = mkHome "amd";

        # NVIDIA GPU (for desktop or other machines with NVIDIA cards)
        stephan-nvidia = mkHome "nvidia";

        # CPU-only fallback (no GPU acceleration)
        stephan-cpu = mkHome "cpu";

        # Raspberry Pi 3B — lightweight aarch64 environment
        # Usage: home-manager switch --flake ~/.config/home-manager#pi
        pi = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs-pi;
          modules = [
            nixvim.homeModules.nixvim
            ./home-pi.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            pkgs-unstable = pkgs-pi-unstable;
          };
        };
      };
    };
}
