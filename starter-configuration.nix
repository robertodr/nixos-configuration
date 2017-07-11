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
    stdenv
    findutils
    coreutils
    gnumake
    psmisc
    iputils
    nettools
    netcat
    rsync
    htop
    iotop
    python
    file
    bc
    wget
    curl
    unrar
    tree
    unzip
    fish
    neovim
    git

    # nix
    nix-repl
    nix-prefetch-git
    nixos-container
    patchelf
  ];

  programs.fish.enable = true;
  programs.tmux.enable = true;
  
  # editor is always nvim
  environment.variables.EDITOR = "nvim";
  
  virtualisation.docker.enable = false;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.roberto = {
    description = "Roberto Di Remigio";
    extraGroups = [
      "users"
      "wheel" 
      "disk" 
      "audio" 
      "video"
      "networkmanager" 
      "systemd-journal"
      "root" 
      "adm" 
      "cdrom"
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
