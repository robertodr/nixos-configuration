{ config, pkgs, ... }:
{
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
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
    #kbfs = {
    #  enable = true;
    #};
    #keybase = {
    #  enable = true;
    #};
    emacs = {
      enable = true;
    };
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "it";
      xkbOptions = "eurosign:e";
      desktopManager.xterm.enable = false;
      displayManager.gdm = {
        enable = true;
      };
      #displayManager.slim = {
      #  enable = false;
      #  defaultUser = "roberto";
      #  theme = pkgs.fetchurl {
      #    url = "https://github.com/robertodr/nixos-pulse-demon-slim/archive/v1.0.tar.gz";
      #    sha256 = "09z8y6fac9l9805f2j3q3zbidymx3s7hysx23vb07pc1s4n6874x";
      #  };
      #};
      desktopManager.gnome3 = {
        enable = true;
      };
      #windowManager.xmonad = {
      #  enable = false;
      #  enableContribAndExtras = true;
      #  extraPackages = haskellPackages: [
      #    haskellPackages.taffybar
      #    haskellPackages.xmonad
      #    haskellPackages.xmonad-contrib
      #    haskellPackages.xmonad-extras
      #  ];
      #};
    };
    nixosManual.showManual = true;
  };

  fonts = {
    fontconfig = {
      enable = true;
    };
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      terminus_font
      corefonts           # Microsoft free fonts
      inconsolata         # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont             # some international languages
      font-awesome-ttf
      hack-font
    ];
  };
}
