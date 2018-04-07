{ config, pkgs, ... }:
{
  fonts = {
    fontconfig.enable = true;
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts           # Microsoft free fonts
      dejavu_fonts
      font-awesome-ttf
      gyre-fonts
      hack-font
      inconsolata         # monospaced
      latinmodern-math
      lato
      source-code-pro
      terminus_font
      ubuntu_font_family  # Ubuntu fonts
      unifont             # some international languages
    ];
  };
}
