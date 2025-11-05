{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # PR #458696 - super-productivity 16.2.1 update (temporary workaround until merged)
    nixpkgs-super-productivity-16-2-1.url = "github:pineapplehunter/nixpkgs/supprod";
    
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    
    stylix.url = "github:danth/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-super-productivity-16-2-1,
    home-manager,
    nixgl,
    stylix,
    ...
  } @ inputs: {
    homeConfigurations = {
      stephan = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
          overlays = [nixgl.overlay];
        };
        modules = [
          stylix.homeModules.stylix
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          nixgl = nixgl;
          pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
          pkgs-super-productivity-16-2-1 = import nixpkgs-super-productivity-16-2-1 {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
            };
          };
        };
      };
    };
  };
}
