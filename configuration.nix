# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./users.nix
      ./services-fonts.nix
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
  environment.systemPackages = with pkgs; 
  let
    nix-home = pkgs.callPackage ./nix-home.nix {};
    ninja-kitware = pkgs.callPackage ./ninja-kitware.nix {};
    core-packages = [
      acpi          
      atool
      autoconf
      automake
      bc               
      bgs
      binutils
      bmon
      cmake
      coreutils
      cryptsetup
      ctags
      curl
      direnv
      dmenu
      dunst
      file
      findutils
      fish
      fuse
      gcc
      gitFull
      gnumake
      htop
      i3lock
      inotify-tools
      iotop
      iputils
      libreoffice
      neovim
      netcat
      nettools
      ninja-kitware
      nmap
      ack
      psmisc
      rsync
      stdenv
      traceroute
      tree
      unrar
      unzip 
      wget
      which
      xbindkeys
      xclip
      xlibs.xinput
      xlibs.xmodmap
      xorg.xmessage
      xorg.xvinfo
      xsel
      zip
    ];
    crypt-packages = [
      git-crypt
      gnupg1
      keybase
    ];
    haskell-packages = with haskellPackages; [
      alex
      cabal-install
      cabal2nix
      ghc
      ghc-mod
      happy
      hindent
      hlint
      hscolour
      stack
    ];
    nix-packages = [                   
      nix-home
      nix-prefetch-git
      nix-repl
      nixos-container
      nixpkgs-lint
      nox
      patchelf
    ];
    python-packages = with python35Packages; [
      jupyter    
      matplotlib
      numpy
      python3
      pyyaml
      scipy
      sphinx
      sympy
    ];
    texlive-packages = [
      biber                            
      (texlive.combine {
         inherit (texlive) 
         collection-basic
         collection-bibtexextra
         collection-binextra
         collection-fontsextra
         collection-fontsrecommended
         collection-fontutils
         collection-formatsextra
         collection-genericextra
         collection-genericrecommended
         collection-langenglish
         collection-langeuropean
         collection-langitalian
         collection-latex
         collection-latexextra
         collection-latexrecommended
         collection-luatex
         collection-mathextra
         collection-metapost
         collection-pictures
         collection-plainextra
         collection-pstricks
         collection-publishers
         collection-science
         collection-xetex;
      })
    ];
    user-packages = [                   
      areca         
      aspell
      aspellDicts.en
      aspellDicts.it
      aspellDicts.nb
      calibre
      drive 
      evince
      feh
      firefox
      geeqie
      ghostscript
      chromium
      imagemagick
      liferea
      meld
      pass
      pdftk
      phototonic
      quasselClient
      rambox
      spotify
      taskwarrior
      vlc
    ];
  in 
    core-packages ++
    crypt-packages ++
    haskell-packages ++
    nix-packages ++
    python-packages ++
    texlive-packages ++
    user-packages;

  programs.fish.enable = true;
  programs.tmux.enable = true;
  
  virtualisation.docker.enable = true;
  
  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
