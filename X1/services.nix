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
    hardware = {
      bolt.enable = true;
    };

    printing = {
      enable = true;
    };

    #thermald.enable = true;
    tlp.enable = false;

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
  };

  systemd = {
    tmpfiles.rules = [ "d /tmp 1777 root root 10d" ];
  };
}
