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
    extraHosts = "52.3.234.160  lipa.ms.mff.cuni.cz";
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "it";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  nixpkgs = {
    config = {
      # Allow proprietary packages
      allowUnfree = true;
      # Create an alias for the unstable channel
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          # pass the nixpkgs config to the unstable alias
          # to ensure `allowUnfree = true;` is propagated:
          config = config.nixpkgs.config;
        };
      };
    };
    overlays = [(self: super: {
      direnv = super.unstable.direnv;
      exa = super.unstable.exa;
      neovim = super.neovim.override {
        withPython = true;
        withPython3 = true;
        extraPython3Packages = with super.python35Packages; [
          jedi
          yapf
        ];
        vimAlias = true;
      };
      spotify = super.unstable.spotify;
      watson-ruby = super.unstable.watson-ruby;
    })];
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
  let
    nix-home = pkgs.callPackage ./nix-home.nix {};
    ninja-kitware = pkgs.callPackage ./ninja-kitware.nix {};
    core-packages = [
      ack
      acpi
      atool
      bc
      bgs
      binutils
      bmon
      busybox
      compton
      coreutils
      cryptsetup
      ctags
      curl
      direnv
      dmenu
      dunst
      emacs25-nox
      file
      findutils
      fish
      fuse
      gnome3.caribou
      gnome3.gnome_terminal
      htop
      i3lock
      inotify-tools
      iputils
      neovim
      netcat
      nettools
      nmap
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
      kbfs
      keybase
      keybase-gui
    ];
    development-packages = [
      autoconf
      automake
      clang-tools
      cmake
      gcc
      gitFull
      gnumake
      ninja-kitware
      watson-ruby
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
      jedi
      jupyter
      matplotlib
      numpy
      python3
      pyyaml
      scipy
      sphinx
      sympy
      yapf
    ];
    rust-packages = [
      cargo
      rustc
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
      chromium
      drive
      evince
      feh
      firefox
      geeqie
      ghostscript
      imagemagick
      libreoffice
      liferea
      meld
      pass
      pdftk
      phototonic
      quasselClient
      rambox
      shutter
      spotify
      taskwarrior
      transmission
      transmission_gtk
      vlc
    ];
  in
    core-packages ++
    crypt-packages ++
    development-packages ++
    haskell-packages ++
    nix-packages ++
    python-packages ++
    rust-packages ++
    texlive-packages ++
    user-packages;

  environment.variables.EDITOR = "nvim";

  programs.fish.enable = true;
  programs.tmux.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
