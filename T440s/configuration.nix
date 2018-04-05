# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./users.nix
      ./services.nix
      ./fonts.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/sda";
    };
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/sda3";
        preLVM = true;
      }
    ];
  };

  networking = {
    hostName = "minazo";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # Home: "Europe/Amsterdam";
  # Virginia: "America/New_York";
  time.timeZone = "America/New_York";

  nixpkgs = {
    config = {
      # Allow proprietary packages
      allowUnfree = true;
      allowBroken = false;
      # Configure Firefox
      firefox = {
       enableGnomeExtensions = true;
       enableGoogleTalkPlugin = true;
      };
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
      neovim = super.neovim.override {
        withPython = true;
        withPython3 = true;
        vimAlias = true;
      };
      ninja-kitware = super.callPackage ./rdrpkgs/ninja-kitware {};
      nix-home = super.callPackage ./rdrpkgs/nix-home {};
    })];
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs;
    let
      core-packages = [
        acpi
        atool
        bc
        binutils
        busybox
        coreutils
        cryptsetup
        ctags
        curl
        direnv
        dpkg
        exa
        file
        findutils
        gnome3.caribou
        gnome3.gconf
        gnome3.gnome_terminal
        htop
        inotify-tools
        iputils
        neovim
        psmisc
        rsync
        tree
        unrar
        unzip
        wget
        which
        xbindkeys
        xclip
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
        gcc
        gitFull
        gnumake
        ninja-kitware
        watson-ruby
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
      python-packages = [
        python3Full
        python3Packages.jedi
        python3Packages.yapf
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
           #collection-genericextra
           #collection-genericrecommended
           collection-langenglish
           collection-langeuropean
           collection-langitalian
           collection-latex
           collection-latexextra
           collection-latexrecommended
           collection-luatex
           #collection-mathextra
           collection-metapost
           collection-pictures
           #collection-plainextra
           collection-pstricks
           collection-publishers
           #collection-science
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
        ghostscript
        imagemagick
        libreoffice
        liferea
        meld
        pass
        pdftk
        phototonic
        rambox
        shutter
        spotify
        taskwarrior
        transmission
        transmission_gtk
        vlc
      ];
    in
      core-packages
      ++ crypt-packages
      ++ development-packages
      ++ nix-packages
      ++ python-packages
      ++ texlive-packages
      ++ user-packages;

    gnome3.excludePackages = with pkgs.gnome3; [ epiphany evolution totem vino yelp accerciser ];
    variables.EDITOR = "nvim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish.enable = true;
    tmux.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";

}
