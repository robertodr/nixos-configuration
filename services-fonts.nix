{ config, pkgs, ... }:
{
  # Enable CUPS to print documents.
  services = {
    printing.enable = true;
    # Enable the X11 windowing system.                                             
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "it";
      xkbOptions = "eurosign:e";
      desktopManager.xterm.enable = false;
                                                                                   
      # SLiM
      displayManager.slim = {
        enable = true;
        defaultUser = "roberto";
        theme = pkgs.fetchurl {
          url = "https://github.com/robertodr/nixos-pulse-demon-slim/archive/v1.0.tar.gz";
          sha256 = "09z8y6fac9l9805f2j3q3zbidymx3s7hysx23vb07pc1s4n6874x";
        };
      }; 
      # GNOME3
      desktopManager.gnome3.enable = true;
      # xmonad
      windowManager.xmonad = { 
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad-contrib
          haskellPackages.xmonad-extras
          haskellPackages.xmonad
        ];
      };
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
