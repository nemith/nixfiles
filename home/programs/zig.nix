{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    bbennett.programs.zig.enable = lib.mkEnableOption "zig language";
  };

  config = lib.mkIf config.bbennett.programs.zig.enable {
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
