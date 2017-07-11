{ config, pkgs, ... }:
{
  environment.variables.BROWSER = "google-chrome";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    enableCtrlAltBackspace = true;
    layout = "it";
    xkbOptions = "eurosign:e";

    # Enable XMonad
    displayManager.slim.enable = true;
    displayManager.slim.defaultUser = "roberto";
    desktopManager.gnome3.enable = true;
    desktopManager.xterm.enable = false;
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
  };

  services.nixosManual.showManual = true;
  
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
