{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.zig.enable = lib.mkEnableOption "zig language";
  };

  config = lib.mkIf config.bbennett.zig.enable {
    home.packages = with pkgs; [
      zig
      zls
    ];

    programs.vscode = {
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          ziglang.vscode-zig
        ];
        userSettings = {
          "zig.zls.enabled" = "on";
        };
      };
    };
  };
}
