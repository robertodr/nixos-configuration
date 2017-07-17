# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./users.nix
      ./minazo.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda3";
      preLVM = true;
    }
  ]; 

  networking = {
    hostName = "minazo"; # Define your hostname.
    networkmanager.enable = true; 
    # Needed to install TeXLive
    extraHosts = "52.3.234.160	lipa.ms.mff.cuni.cz";
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "it";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config = {
    allowUnfree = true;
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # core
    bc
    coreutils
    curl
    file
    findutils
    fish
    git
    gnumake
    htop
    iotop
    iputils
    neovim
    netcat
    nettools
    psmisc
    python
    rsync
    stdenv
    tree
    unrar
    unzip 
    wget

    # nix
    nix-prefetch-git
    nix-repl
    nixos-container
    nox
    patchelf
  ]
  ++ (import ./env.nix pkgs);

  programs.fish.enable = true;
  programs.tmux.enable = true;
  
  # editor is always nvim
  environment.variables.EDITOR = "nvim";
  
  virtualisation.docker.enable = false;
  
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
