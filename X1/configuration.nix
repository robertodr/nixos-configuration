# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  baseConfig = {
    # Allow proprietary packages
    allowUnfree = true;
    allowBroken = false;
  };
  nixos-hardware = builtins.fetchTarball {
    # Fetched on 2020-02-23
    url = "https://github.com/NixOS/nixos-hardware/archive/5904e7605c5c6b26994e3b49153feaa29c35e388.tar.gz";
    sha256 = "1mij86a68j3cm97nx5gg6bkjsbv6nr5h3az7bcnghsxzy4w33lch";
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

  nix = {
    autoOptimiseStore = true;
    buildCores = 2;
    trustedUsers = [
      "root"
      "roberto"
    ];
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
    config = baseConfig // {};
    overlays = [
      (
        self: super: {
          nix-home = super.callPackage ./pkgs/nix-home {};
        }
      )
    ];
  };

  # List packages installed in system profile.
  environment = {
    gnome3.excludePackages = with pkgs.gnome3; [ epiphany totem ];
    variables.EDITOR = "emacs -nw";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    singularity.enable = true;
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
