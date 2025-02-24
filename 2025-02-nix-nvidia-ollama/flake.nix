{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { ... }@inputs:
    with inputs;
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      libx = import ./lib { inherit inputs outputs stateVersion; };

    in {

      nixosConfigurations = {
        nix-llm = libx.mkNixos { "x86_64-linux" "nix-llm" "zaphod" };
      }

   };
}