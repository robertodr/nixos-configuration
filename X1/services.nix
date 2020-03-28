{ config, pkgs, ... }:

{
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = "load-module module-switch-on-connect";
    };

    bluetooth = {
      enable = true;
      extraConfig = "
        [General]
        Enable=Source,Sink,Media,Socket
      ";
    };
  };

  services = {
    borgbackup.jobs = {
      roberto = rec {
        user = "roberto";
        paths = [ "/home/${user}/Pictures" ];
        #exclude = [ "/nix" "'**/.cache'" ];
        doInit = false;
        repo = "fxppmn0g@fxppmn0g.repo.borgbase.com:repo";
        encryption = {
          mode = "repokey-blake2";
          passCommand = "pass show ${repo}";
        };
        environment = { BORG_RSH = "ssh -i /home/${user}/.ssh"; };
        compression = "auto,lzma";
        startAt = "daily";
      };
    };

    hardware = {
      bolt.enable = true;
    };

    kbfs.enable = true;
    keybase.enable = true;
    printing.enable = true;

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
        naturalScrolling = true;
        scrollMethod = "twofinger";
        clickMethod = "clickfinger";
      };
      # Desktop manager
      desktopManager = {
        gnome3.enable = true;
        xterm.enable = false;
      };
      # Display manager
      displayManager = {
        gdm.enable = true;
        # FIXME true should be (and was) perfectly fine until 2020-02-23
        gdm.wayland = false;
      };
    };

    # Needed for U2F auth
    #pcscd.enable = true;
    #udev.packages = with pkgs; [
    #  libu2f-host
    #  yubikey-personalization
    #];
    #thermald.enable = true;
    tlp.enable = false;
  };

  systemd = {
    tmpfiles.rules = [ "d /tmp 1777 root root 10d" ];
  };
}
