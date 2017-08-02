# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda3";
      preLVM = true;
    }
  ]; 

  networking.hostName = "minazo"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "it";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config.allowUnfree = true;
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
    gitFull
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
    patchelf
  ];

  programs.fish.enable = true;
  programs.tmux.enable = true;
  
  # editor is always nvim
  environment.variables.EDITOR = "nvim";
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;
    layout = "it";
    xkbOptions = "eurosign:e";

    # Enable XMonad
    displayManager.slim.enable = true;
    displayManager.slim.defaultUser = "roberto";
    desktopManager.gnome3.enable = true;
    desktopManager.xterm.enable = false;
    windowManager.xmonad = { 
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
  };

  services.nixosManual.showManual = true;

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.roberto = {
    description = "Roberto Di Remigio";
    extraGroups = [
      "adm" 
      "audio" 
      "cdrom"
      "disk" 
      "docker"
      "networkmanager" 
      "root" 
      "systemd-journal"
      "users"
      "video"
      "wheel" 
    ];
    home = "/home/roberto";
    createHome = false;
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/fish";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
