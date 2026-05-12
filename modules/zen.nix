{ self, inputs, ... }:
{
  flake.modules.homeManager.zen =
    { pkgs, ... }:
    {
      imports = [ inputs.zen-browser.homeModules.default ];

      programs.zen-browser = (self.lib.mkFirefoxConfig pkgs) // {
        enable = true;
      };
    };
}
