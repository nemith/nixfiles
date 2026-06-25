{self, ...}: {
  flake.modules.homeManager.develGui = {...}: {
    imports = [
      self.modules.homeManager.vscode
      self.modules.homeManager.zed
    ];
  };
}
