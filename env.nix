pkgs:
with pkgs;
let
  nix-home = pkgs.callPackage ./nix-home.nix {};
  sys = [
    cryptsetup
    docker
    fuse
    nix-home
    nmap
    xclip
    xsel
  ];
  user = [
    drive
    firefox
    gnupg1
    google-chrome
    hack-font
    keybase
    liferea
    meld
    pass
    rambox
    spotify
    taskwarrior
    vlc
    xorg.xmessage
    xorg.xvinfo
  ];
  devel = [
    autoconf
    automake
    boost
    binutils
    ccache
    clang
    cmake
    doxygen
    gcc
    gfortran
    lcov
    libtool
    openmpi
    valgrind
    zlib
  ];
  haskell = with haskellPackages; [
    aeson
    alex
    cabal-install
    cabal2nix
    codex
    contravariant
    cpphs
    ghc
    ghc-mod
    glirc
    haddock
    happy
    hasktags
    hindent
    hlint
    hscolour
    parallel
    pointfree
    pointful
    profunctors
    split
    stack
    tasty
    tasty-hunit
    tasty-smallcheck
    threadscope
  ];
  python27 = with python27Packages; [
    jupyter
    matplotlib
    numpy
    scipy
    sphinx
    sympy
  ];
  tex = [
    biber
    (texlive.combine {
       inherit (texlive) 
       collection-basic
       collection-bibtexextra
       collection-binextra
       collection-fontsextra
       collection-fontsrecommended
       collection-fontutils
       collection-formatsextra
       collection-genericextra
       collection-genericrecommended
       collection-langenglish
       collection-langeuropean
       collection-langitalian
       collection-latex
       collection-latexextra
       collection-latexrecommended
       collection-luatex
       collection-mathextra
       collection-metapost
       collection-pictures
       collection-plainextra
       collection-pstricks
       collection-publishers
       collection-science
       collection-xetex;
    })
  ];
in
    devel ++
    haskell ++
    python27 ++
    sys ++
    tex ++
    user
