{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    handy.url = "github:cjpais/Handy";
    handy.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      ...
    }@inputs:
    {
      homeConfigurations = {
        stephan = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "electron-37.10.3"
              ];
            };
            overlays = [ nixgl.overlay ];
          };
          modules = [
            stylix.homeModules.stylix
            nixvim.homeModules.nixvim
            ./home.nix
          ];
          extraSpecialArgs = {
            inherit inputs;
            nixgl = nixgl;
            handy = handy;
            nixvim = nixvim;
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
                permittedInsecurePackages = [
                  "electron-37.10.3"
                ];
              };
            };
          };
        };
      };
    };
}
