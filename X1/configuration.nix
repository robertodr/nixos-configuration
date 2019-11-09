# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  baseConfig = {
    # Allow proprietary packages
    allowUnfree = true;
    allowBroken = false;
    # Configure Firefox
    firefox = {
      enableGoogleTalkPlugin = true;
      enableBrowserpass = true;
      #enableGnomeExtensions = true;
    };
  };
  nixos-hardware = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixos-hardware/archive/043562906168ee6966b6409c89a2b219af1e9752.tar.gz";
    sha256 = "060ggnrlcdsmzwx8yql005y3m5l3pr4sfdhq744s64b22cs5a739";
  };
  unstable = import <nixos-unstable> { config = baseConfig; };
in
  {
    imports = [
      "${nixos-hardware}/lenovo/thinkpad/x1"
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
    time.timeZone = "Europe/Oslo";
    # Virginia
    #time.timeZone = "America/New_York";
    # Colorado
    #time.timeZone = "America/Denver";

    nixpkgs = {
      config = baseConfig // {
        packageOverrides = pkgs: {
          ccls = unstable.ccls;
          direnv = unstable.direnv;
          emacs = unstable.emacs;
          firefox = unstable.firefox;
          gifski = unstable.gifski;
          kbfs = unstable.kbfs;
          keybase = unstable.keybase;
          keybase-gui = unstable.keybase-gui;
          peek = unstable.peek;
          scribus = unstable.scribus;
          wavebox = unstable.wavebox;
        };
      };
      overlays = [(self: super: {
        git-along = super.callPackage ./pkgs/git-along {};
        neovim = super.neovim.override {
          withPython = true;
          withPython3 = true;
          vimAlias = true;
        };
        nix-home = super.callPackage ./pkgs/nix-home {};
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
          bat
          bc
          bind
          binutils
          coreutils
          cryptsetup
          curl
          direnv
          dmidecode
          editorconfig-core-c
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
          networkmanager-openconnect
          nnn
          openconnect
          opensc
          openvpn
          pciutils
          pcsctools
          pdf-redact-tools
          psmisc
          rsync
          tldr
          tree
          unrar
          unzip
          usbutils
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
          kbfs
          keybase
          keybase-gui
          pass
        ];
        development-packages = [
          autoconf
          automake
          cachix
          ccls
          flameGraph
          git-along
          git-lfs
          gitAndTools.gitFull
          gitAndTools.hub
          global
          gnumake
          include-what-you-use
          libpng
          linuxPackages.perf
          perf-tools
          pijul
          shellcheck
          unifdef
          universal-ctags
        ];
        haskell-packages = [
          #ghc
          haskellPackages.apply-refact
          haskellPackages.hasktags
          haskellPackages.hindent
          haskellPackages.hlint
          haskellPackages.hoogle
          haskellPackages.stylish-haskell
          stack
        ];
        lua-packages = [
          lua
          luaPackages.luacheck
        ];
        nix-packages = [
          nix-home
          nix-prefetch-git
          nixos-container
          nixpkgs-lint
          nox
          patchelf
        ];
        pandoc-packages = [
          pandoc
          haskellPackages.pandoc-crossref
          haskellPackages.pandoc-citeproc
        ];
        python-packages = [
          pypi2nix
          python3Full
          python3Packages.pygments
        ];
        texlive-packages = [
          asymptote
          biber
          git-latexdiff
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
          tectonic
        ];
        user-packages = [
          aspell
          aspellDicts.en
          aspellDicts.it
          aspellDicts.nb
          borgbackup
          chromium
          evince
          firefox
          ghostscript
          gifski
          gimp
          gnome3.geary
          gv
          home-manager
          imagemagick
          inkscape
          krita
          libreoffice
          liferea
          meld
          nixnote2
          pdf2svg
          pdftk
          peek
          potrace
          scribus
          shutter
          spotify
          vlc
          wavebox
          zoom-us
        ];
      in
        core-packages
        ++ crypt-packages
        ++ development-packages
        ++ haskell-packages
        ++ lua-packages
        ++ nix-packages
        ++ pandoc-packages
        ++ python-packages
        ++ texlive-packages
        ++ user-packages;

      gnome3.excludePackages = with pkgs.gnome3; [ epiphany totem ];
      variables.EDITOR = "emacs -nw";
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs = {
      browserpass.enable = true;
      fish.enable = true;
      #light.enable = true;
      singularity.enable = true;
      #ssh.startAgent = true;
      #sway = {
      #  enable = true;
      #  extraPackages = with pkgs; [
      #    dmenu
      #    grim
      #    swayidle
      #    swaylock
      #    xwayland
      #  ];
      #};
      tmux.enable = true;
    };

    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "19.09"; # Did you read the comment?
  }
