# lib/helper.nix
{ inputs, outputs, stateVersion, ... }:
{
  mkNixos = { system, hostname, username, extraModules ? [] }:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit pkgs unstablePkgs inputs system hostname username;
      };
      modules = [
        { nixpkgs.config.allowUnfree = true; }
        (inputs.vscode-server.nixosModules.default or {})

        ../hosts/nixos/${hostname}
        ../hosts/common/nixos-common.nix

        #inputs.disko.nixosModules.disko

      ] ++ extraModules;
    };

}