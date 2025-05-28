# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    # Home Manager NixOS module
    <home-manager/nixos>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  environment.systemPackages = with pkgs; [
    # Core system utilities only
    gcc
    git # version control (system-wide)
    curl # download
    wget # download
    htop # resource monitor
    btop # resource monitor
    tree 
    unzip # zip
    p7zip # 7z
    
    # Essential system tools
    zsh # shell (system-wide)
    
    # Keep these system-wide for all users
    rustup # system-wide rust toolchain
    python3 # system-wide python
  ];

  # Enable Zsh as the default shell (system-wide)
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Home Manager configuration
  home-manager.users.nixos = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  # Enable experimental features for Home Manager
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
