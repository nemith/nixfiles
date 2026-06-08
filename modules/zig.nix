_: {
  flake.modules.homeManager.zig = { pkgs, ... }: {
    home.packages = with pkgs; [ zig ];

    programs.vscode = {
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [ ziglang.vscode-zig ];
        userSettings = {
          "zig.zls.enabled" = "on";
          "zig.zls.path" = "${pkgs.zls}/bin/zls";
        };
      };
    };
  };
}
