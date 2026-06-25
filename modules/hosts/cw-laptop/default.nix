{
  self,
  inputs,
  ...
}: let
  inherit (inputs) nix-darwin home-manager;
  machineName = "CW-HM9D4MQMW2-L";
  primaryUser = "bbennett";
in {
  flake.darwinConfigurations.${machineName} = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    modules = [self.modules.darwin."${machineName}"];
  };

  flake.modules = {
    darwin."${machineName}" = {pkgs, ...}: {
      imports = [
        home-manager.darwinModules.home-manager
        self.modules.darwin.base
        self.modules.darwin.cw
      ];

      system.primaryUser = "${primaryUser}";

      users.users.${primaryUser} = {
        home = "/users/${primaryUser}";
        shell = pkgs.zsh;
      };

      home-manager.users.${primaryUser}.imports = [self.modules.homeManager."${machineName}"];
    };

    homeManager."${machineName}" = {pkgs, ...}: {
      home.stateVersion = "24.11";

      imports = [
        self.modules.homeManager.base
        self.modules.homeManager.darwin
        self.modules.homeManager.shell
        self.modules.homeManager.gui
        self.modules.homeManager.devel
        self.modules.homeManager.develGui
        self.modules.homeManager.cw
      ];

      # VSCode is managed by some MDM shit
      # Work around to set a null package
      # https://github.com/nix-community/home-manager/issues/3375
      programs.vscode.package =
        pkgs.runCommand "dummy" {} "mkdir $out"
        // {
          inherit (pkgs.vscode) pname;
          version = "0.0.0";
        };
    };
  };
}
