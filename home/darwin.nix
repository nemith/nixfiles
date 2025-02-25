{ config, pkgs, ... }:

{
  home.sessionPath = [
    "/opt/homebrew/bin"
  ];

  home.packages = with pkgs; [
    litra-autotoggle
    lima
  ];

  launchd = {
    enable = true;
    agents = {
      litra-autotoggle = {
        enable = true;
        config = {
          ProgramArguments = [
            "${pkgs.litra-autotoggle}/bin/litra-autotoggle"
            # Add any command line arguments here if needed
            # For example: "--brightness" "50"
          ];
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "${config.home.homeDirectory}/.local/state/litra-autotoggle/log";
          # Ensure the program restarts if it fails
          ThrottleInterval = 30;
        };
      };
    };
  };
}
