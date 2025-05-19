{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    nixpkgs,
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
          stylix.homeManagerModules.stylix
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          nixgl = nixgl;
        };
      };
    };
  };
}
