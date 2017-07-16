{ config, pkgs, ... }:
{
  environment.variables.BROWSER = "google-chrome";

  # Enable CUPS to print documents.
  services = {
    printing.enable = true;
    # Enable the X11 windowing system.                                             
    xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "it";
      xkbOptions = "eurosign:e";
                                                                                   
      # SLiM
      displayManager.slim = {
        enable = true;
        defaultUser = "roberto";
        theme = pkgs.fetchurl {
          url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
          sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
        };
        extraConfig = ''
          hidecursor false
        '';
      }; 
      # GNOME3
      desktopManager.gnome3.enable = true;
      desktopManager.xterm.enable = false;
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
