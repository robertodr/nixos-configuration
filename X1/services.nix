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
    avahi = {
      enable = true;
      nssmdns = true;
    };

    printing = {
      enable = true;
      drivers = [
        pkgs.hplip
      ];
    };

    # TODO Probably needs to be changed with 18.09
    kbfs.enable = true;
    keybase.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "us";
      xkbOptions = "eurosign:e";
      # Enable touchpad support.
      libinput = {
        enable = true;
      };
      # Display manager
      displayManager = {
        slim = {
          enable = true;
          defaultUser = "roberto";
          autoLogin = false;
          theme = pkgs.fetchurl {
            url = "https://github.com/robertodr/nixos-pulse-demon-slim/archive/v1.0.tar.gz";
            sha256 = "09z8y6fac9l9805f2j3q3zbidymx3s7hysx23vb07pc1s4n6874x";
          };
        };
        #gdm.enable = true;
      };
      # Window manager
      windowManager = {
        default = "awesome";
        awesome = {
          enable = true;
          package = pkgs.awesome;
        };
      };
      # Desktop manager
      #desktopManager = {
      #  gnome3.enable = true;
      #  xterm.enable = false;
      #};
    };

    redshift = {
      enable = true;
      provider = "geoclue2";
    };

    # Needed for U2F auth
    pcscd.enable = true;
    udev.packages = [
      pkgs.libu2f-host
      pkgs.yubikey-personalization
    ];
  };
}
