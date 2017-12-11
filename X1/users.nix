{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.roberto = {
    description = "Roberto Di Remigio";
    group = "roberto";
    extraGroups = [
      "adm"
      "audio"
      "cdrom"
      "disk"
      "docker"
      "networkmanager"
      "root"
      "systemd-journal"
      "users"
      "video"
      "wheel"
    ];
    home = "/home/roberto";
    createHome = true;
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/fish";
  };
}
