{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/nixos/nix.nix
    ./../../modules/nixos/boot.nix

    ./../../modules/nixos/locale.nix
    ./../../modules/nixos/fonts.nix
    ./../../modules/nixos/users.nix

    ./../../modules/nixos/external-binaries.nix

    ./../../modules/nixos/firmware.nix
    ./../../modules/nixos/security.nix
    ./../../modules/nixos/appimage.nix
    ./../../modules/nixos/network.nix
    ./../../modules/nixos/power.nix

    ./../../modules/nixos/rescue.nix
    ./../../modules/nixos/storage.nix
  ];
}
