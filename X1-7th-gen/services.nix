{ config, pkgs, ... }:

{
  hardware = {
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      extraConfig = "load-module module-switch-on-connect";
    };

    bluetooth = {
      enable = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };
  };

  services = {
    flox.substituterAdded = true;

    emacs = {
      defaultEditor = true;
      enable = true;
      install = true;
      package = pkgs.callPackage ./emacs.nix { };
    };

    hardware = {
      bolt.enable = true;
    };

    fwupd.enable = true;
    kbfs.enable = true;
    keybase.enable = true;
    printing.enable = true;
    thermald.enable = true;
    thinkfan.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 25;
      enableCtrlAltBackspace = true;
      exportConfiguration = true;
      # Enable touchpad support.
      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
          scrollMethod = "twofinger";
          clickMethod = "clickfinger";
        };
      };
      # Desktop manager
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };
      # Display manager
      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
      };
      windowManager = {
        i3 = {
          enable = false;
        };
      };
    };
  };

  systemd = {
    tmpfiles.rules = [ "d /tmp 1777 root root 10d" ];
  };
}
