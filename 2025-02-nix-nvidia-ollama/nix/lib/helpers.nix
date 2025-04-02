# lib/helper.nix
{ inputs, outputs, stateVersion, ... }:
{
  mkNixos = { system, hostname, username, extraModules ? [] }:
    let
      pkgs = import inputs.nixpkgs { inherit system; config.allowUnfree = true; };
      unstablePkgs = import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs unstablePkgs inputs system hostname username; };
      modules = [
        (inputs.vscode-server.nixosModules.default or {})
        ../hosts/nixos/${hostname}
        ../hosts/common/nixos-common.nix
      ] ++ extraModules;
    };
}