{ pkgs, ... }:

{
  users.extraGroups = [
    {
      name = "roberto";
      gid = 1000;
    }
  ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.roberto = {
    description = "Roberto Di Remigio";
    group = "roberto";
    extraGroups = [
      "users"
      "wheel" 
      "disk" 
      "audio" 
      "video"
      "networkmanager" 
      "systemd-journal"
      "root" 
      "adm" 
      "cdrom"
    ];
    home = "/home/roberto";
    createHome = false;
    isNormalUser = true;
    uid = 1000;
    shell = "/run/current-system/sw/bin/fish";
  };
}
