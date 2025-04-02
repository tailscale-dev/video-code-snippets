{ inputs, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  environment.systemPackages = with pkgs; [
    ## stable
    ansible
    drill
    figurine
    git
    htop
    iperf3
    just
    python3
    tree
    watch
    wget
    vim

    # requires nixpkgs.config.allowUnfree = true;
    vscode-extensions.ms-vscode-remote.remote-ssh

    #nixpkgs-unstable.legacyPackages.${pkgs.system}.beszel
  ];
}