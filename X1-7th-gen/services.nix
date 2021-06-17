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

    borgbackup.jobs = {
      roberto = rec {
        user = "roberto";
        paths = [
          "/home/${user}/Documents"
          "/home/${user}/Downloads"
          "/home/${user}/Pictures"
        ];
        #exclude = [ "/nix" "'**/.cache'" ];
        doInit = false;
        repo = "yc4l17r5@yc4l17r5.repo.borgbase.com:repo";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "${pkgs.pass}/bin/pass show yc4l17r5.repo.borgbase.com";
        };
        environment = { BORG_RSH = "${pkgs.openssh_gssapi_heimdal}/bin/ssh"; };
        compression = "auto,lzma";
        startAt = "Thu *-*-* 14:00:00";
      };
    };

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
