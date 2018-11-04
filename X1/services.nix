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
    #avahi = {
    #  enable = true;
    #  nssmdns = true;
    #};

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        hplip
        hplipWithPlugin
      ];
    };

    kbfs.enable = true;
    keybase.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      exportConfiguration = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      # Enable touchpad support.
      libinput = {
        enable = true;
        naturalScrolling = true;
        scrollMethod = "twofinger";
        clickMethod = "clickfinger";
      };
      # Display manager
      displayManager = {
        gdm.enable = true;
      #  lightdm = {
      #    enable = true;
      #    autoLogin.enable = false;
      #    background = "/home/roberto/.background-image";
      #  };
      };
      # Desktop manager
      desktopManager = {
        gnome3.enable = true;
        xterm.enable = false;
      };
      # Window manager
      #windowManager = {
      #  default = "awesome";
      #  awesome = {
      #    enable = true;
      #    package = pkgs.awesome;
      #    luaModules = with pkgs.luaPackages; [
      #      lgi
      #    ];
      #  };
      #};
    };

    # Needed for U2F auth
    pcscd.enable = true;
    udev.packages = with pkgs; [
      libu2f-host
      yubikey-personalization
    ];
  };
}
