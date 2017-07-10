pkgs:
with pkgs;
let
  nix-home = pkgs.callPackage ./nix-home.nix {};
  sys = [
    dpkg
    cryptsetup
    fuse
    nmap
    xsel
    docker
  ];
  user = [
    st
    keybase
    gnupg1
    google-chrome
    firefox
    taskwarrior
    pass
    nix-home
    spotify
    drive
    gnupg
    liferea
    meld
    rambox
    thunderbird
    vlc
    xorg.xmessage
    xorg.xvinfo
  ];
  devel = [
    lcov
    git
    patchelf
    binutils
    gcc
    gfortran
    openmpi
    clang
    doxygen
    cmake
    automake
    autoconf
    libtool
  ];
  haskell = with haskellPackages; [
    ghc
    cabal-install
    cabal2nix
    ghc-mod
    stack
    alex
    happy
    cpphs
    hscolour
    hlint
    haddock
    pointfree
    pointful
    hasktags
    threadscope
    hindent
    codex
    parallel
    aeson
    split
    tasty
    tasty-hunit
    tasty-smallcheck
    contravariant
    profunctors
    glirc
  ];
  python27 = with python27Packages; [
    jupyter
    matplotlib
    numpy
    scipy
    sympy
    sphinx
  ];
in
    user ++
    devel ++
    haskell ++
    python27
