_: {
  flake.modules.homeManager.ssh =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [ sshpass ];

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            addKeysToAgent = "yes";
            extraOptions = lib.optionalAttrs pkgs.stdenv.isDarwin { UseKeychain = "yes"; };
          };
        };
      };
    };
}
