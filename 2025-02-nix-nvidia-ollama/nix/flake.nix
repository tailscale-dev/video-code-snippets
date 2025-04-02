{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { ... }@inputs:
    with inputs;
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      libx = import ./lib { inherit inputs outputs stateVersion pkgs; };
    in {
      nixosConfigurations = {
        nix-llm = libx.mkNixos {
          system = "x86_64-linux";
          hostname = "nix-llm";
          username = "zaphod";
        };
      };
   };
}