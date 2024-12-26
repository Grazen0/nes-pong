{
  description = "Pong game for the NES";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
  }: let
    eachSystem = nixpkgs.lib.genAttrs (import systems);
    pkgsFor = nixpkgs.legacyPackages;
  in {
    packages = eachSystem (system: {
      default = pkgsFor.${system}.callPackage ./default.nix {};
    });

    devShells = eachSystem (system: {
      default = pkgsFor.${system}.callPackage ./shell.nix {};
    });
  };
}
