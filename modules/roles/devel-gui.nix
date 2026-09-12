{ self, ... }: {
  flake.modules.homeManager.develGui = { ... }: { imports = [ self.modules.homeManager.zed ]; };
}
