{ config, lib, pkgs, inputs, ... }:
  with lib;
{
  # set nix-ld to expose linux loader
  programs.nix-ld.enable = true;

  # install nix-alien
  environment.systemPackages = with inputs.nix-alien.packages.${pkgs.system};
    [
      nix-alien
    ];
}
