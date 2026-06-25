_: {
  flake.modules.homeManager.go = {
    config,
    pkgs,
    ...
  }: let
    goPath = "${config.home.homeDirectory}/.local/go";
  in {
    home.sessionPath = ["${goPath}/bin"];

    home.packages = with pkgs; [
      delve
      gofumpt
      golangci-lint
      gotestsum
      gotools
    ];

    programs.go = {
      package = pkgs.go_1_26;
      enable = true;
      env.GOPATH = goPath;
      telemetry.mode = "off";
    };
  };
}
