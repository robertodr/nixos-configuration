{ pkgs, ... }:

{
  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      dejavu_fonts
      fira-code
      fira-code-symbols
      font-awesome-ttf
      font-awesome_4
      font-awesome_5
      google-fonts
      gyre-fonts
      hack-font
      hasklig
      inconsolata # monospaced
      latinmodern-math
      lato
      monoid
      nerdfonts
      noto-fonts
      open-sans
      source-code-pro
      source-sans-pro
      source-serif-pro
      terminus_font
      tex-gyre-bonum-math
      tex-gyre-pagella-math
      tex-gyre-schola-math
      tex-gyre-termes-math
      ubuntu_font_family # Ubuntu fonts
      unifont # some international languages
      xits-math
    ];
  };
}
