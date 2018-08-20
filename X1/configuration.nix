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
      ./multi-glibc-locale-paths.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernel = {
      sysctl = {
        "kernel.perf_event_paranoid" = 0;
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/nvme0n1";
    };
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/nvme0n1p3";
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
  #time.timeZone = "Europe/Amsterdam";
  # Virginia
  time.timeZone = "America/New_York";

  nixpkgs = {
    config = {
      # Allow proprietary packages
      allowUnfree = true;
      allowBroken = false;
      # Configure Firefox
      firefox = {
       enableGoogleTalkPlugin = true;
      };
      # Create an alias for the unstable channel
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          # Pass the nixpkgs config to the unstable alias
          # to ensure `allowUnfree = true;` is propagated:
          config = config.nixpkgs.config;
        };
      };
    };
    overlays = [(self: super: {
      emacs = super.unstable.emacs;
      kitty = super.unstable.kitty;
      firefox = super.unstable.firefox;
      neovim = super.neovim.override {
        withPython = true;
        withPython3 = true;
        vimAlias = true;
      };
      ninja-kitware = super.callPackage ./rdrpkgs/ninja-kitware {
        python = super.python3;
      };
      nix-home = super.callPackage ./rdrpkgs/nix-home {};
      openvpn = super.openvpn.override {
        pkcs11Support = true;
      };
    })];
  };

  # List packages installed in system profile.
  environment = {
    systemPackages = with pkgs;
    let
      core-packages = [
        acpi
        ag
        atool
        bc
        binutils
        busybox
        coreutils
        cryptsetup
        ctags
        curl
        direnv
        emacs
        exa
        file
        findutils
        freerdp
        htop
        inotify-tools
        iputils
        kitty
        ncurses.dev
        neovim
        networkmanager
        nnn
        opensc
        openvpn
        pcsctools
        psmisc
        rsync
        slock
        tldr
        tree
        unrar
        unzip
        wget
        which
        xbindkeys
        xclip
        xdg_utils
        xsel
        zip
      ];
      crypt-packages = [
        git-crypt
        gnupg1
        # Needed for U2F auth
        libu2f-host
        yubikey-personalization
        # TODO This package should be in 18.09
        #keybase
      ];
      development-packages = [
        autoconf
        automake
        clang-tools
        flameGraph
        gcc
        git-lfs
        gitFull
        global
        gnumake
        linuxPackages.perf
        lua
        # FIXME Commented because package is broken
        #luaPackages.luacheck
        ninja-kitware
        perf-tools
        shellcheck
      ];
      haskell-packages = [
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
      python-packages = [
        autoflake
        pipenv
        python3Full
        python3Packages.isort
        python3Packages.jedi
        python3Packages.pygments
        python3Packages.pytest
        python3Packages.yapf
      ];
      texlive-packages = [
        asymptote
        biber
        (texlive.combine {
           inherit (texlive)
           collection-basic
           collection-bibtexextra
           collection-binextra
           collection-context
           collection-fontsextra
           collection-fontsrecommended
           collection-fontutils
           collection-formatsextra
           collection-langenglish
           collection-langeuropean
           collection-langfrench
           collection-langitalian
           collection-langother
           collection-latex
           collection-latexextra
           collection-latexrecommended
           collection-luatex
           collection-mathscience
           collection-metapost
           collection-pictures
           collection-plaingeneric
           collection-pstricks
           collection-publishers
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
        dropbox-cli
        evince
        feh
        firefox
        ghostscript
        gimp
        gv
        imagemagick
        inkscape
        libreoffice
        liferea
        meld
        pandoc
        pass
        pdftk
        phototonic
        pymol
        shutter
        spotify
        taskwarrior
        transmission
        transmission_gtk
        vlc
        xournal
        zathura
      ];
    in
      core-packages
      ++ crypt-packages
      ++ development-packages
      ++ haskell-packages
      ++ nix-packages
      ++ python-packages
      ++ texlive-packages
      ++ user-packages;

    variables.EDITOR = "emacs";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    fish.enable = true;
    tmux.enable = true;
    ssh.startAgent = true;
  };

  # Needed to avoid OOM error from slock
  # see also: https://github.com/NixOS/nixpkgs/issues/9656
  security.wrappers = {
    slock.source = "${pkgs.slock.out}/bin/slock";
   };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
