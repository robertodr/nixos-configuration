# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:
let
  baseConfig = {
    allowUnfree = true;
  };
  unstable = import <nixos-unstable> { config = baseConfig; };
in
{
  imports = [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/x1/7th-gen"
    (import (fetchTarball "https://github.com/flox/nixos-module/archive/master.tar.gz"))
    ./hardware-configuration.nix
    ./users.nix
    ./services.nix
    ./fonts.nix
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
    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p3";
        preLVM = true;
      };
    };
  };

  networking = {
    hostName = "pulsedemon";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
  };

  nix = {
    autoOptimiseStore = true;
    buildCores = 2;
    trustedUsers = [
      "root"
      "roberto"
    ];
    nixPath = options.nix.nixPath.default ++ [
      "nixpkgs-overlays=/etc/nixos/overlays-compat/"
    ];
  };

  nixpkgs = {
    config = baseConfig // {
      packageOverrides = pkgs: {
        gnome-firmware-updater = unstable.gnome-firmware-updater;
        gnomeExtensions.paperwm = unstable.gnomeExtensions.paperwm;
        kbfs = unstable.kbfs;
        keybase = unstable.keybase;
        keybase-gui = unstable.keybase-gui;
        poetry = unstable.poetry;
        virtualbox = unstable.virtualbox;
      };
      permittedInsecurePackages = [
        "openssh-with-gssapi-8.4p1"
      ];
    };
    overlays = [
      (
        post: pre: {
          openssh_gssapi_heimdal = pre.openssh_gssapi.override {
            withKerberos = true;
            libkrb5 = post.heimdalFull;
          };
        }
      )
    ];
  };

  # Select internationalisation properties.
  console = {
    keyMap = "us";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # Home: "Europe/Stockholm";
  time.timeZone = "Europe/Stockholm";
  # Virginia
  #time.timeZone = "America/New_York";
  # Colorado
  #time.timeZone = "America/Denver";

  environment = {
    systemPackages = with pkgs; [
      acpi
      atool
      binutils
      borgbackup
      brave
      cacert
      coreutils
      cryptsetup
      curl
      dmidecode
      file
      findutils
      gnome-firmware-updater
      gnome3.gnome-tweaks
      gnomeExtensions.paperwm
      gnupg1
      keybase-gui
      neovim
      pass
      patchelf
      pciutils
      poetry
      psmisc
      rsync
      squashfsTools
      tree
      unrar
      unzip
      usbutils
      wget
      which
      xbindkeys
      xclip
      xdg_utils
      xorg.lndir
      xsel
      zip
    ];
    gnome.excludePackages = with pkgs.gnome3; [ epiphany geary totem ];
  };

  programs = {
    browserpass.enable = true;
    singularity.enable = true;
    ssh.package = pkgs.openssh_gssapi_heimdal;
  };

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    virtualbox.host = {
      enable = true;
      #  enableExtensionPack = true;
    };
  };

  system.stateVersion = "21.05";

  krb5 = {
    enable = true;
    kerberos = pkgs.heimdalFull;
    domain_realm = {
      ".pdc.kth.se" = "NADA.KTH.SE";
    };
    appdefaults = {
      forwardable = "yes";
      forward = "yes";
      krb4_get_tickets = "no";
    };
    libdefaults = {
      default_realm = "NADA.KTH.SE";
      dns_lookup_realm = true;
      dns_lookup_kdc = true;
    };
  };
}
