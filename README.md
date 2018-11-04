# nixos-configuration

NixOS configuration, pilfered from [juselius/nixos-configuration](https://github.com/juselius/nixos-configuration), MIT-licensed.

1. Download the NixOS [minimal installation CD](https://nixos.org/nixos/download.html)
2. Install NixOS by following the [installation instructions](https://nixos.org/nixos/manual/index.html#sec-installation)

Configure the base OS:

    # nix-env -i git vim
    # cd /tmp
    # git clone https://github.com/robertodr/nixos-configuration
    # cp nixos-configuration/*.nix /etc/nixos/
    # vim /etc/nixos/configuration.nix
    # nixos-rebuild switch
    # reboot

Don't forget to add channels (using `sudo` in case)

    # nix-channel --add https://nixos.org/channels/nixos-18.03 nixos
    # nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
    # nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware

**WARNING** The configuration in the repo might not _always_ work successfully due to some packages.
In case that happens, comment them and proceed with installation. You can fix those packages afterwards.

Configure the user account:

    # su - username
    $ git clone https://github.com/robertodr/dots .dots
    $ git clone https://github.com/robertodr/xmonad .xmonad
    $ ln -s .dots/default.nix .
    $ vim default.nix
    $ nix-home
