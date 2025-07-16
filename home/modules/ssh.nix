{ config, lib, ... }:
with lib;
let
  cfg = config.programs.bbennett.ssh-term;
in
{
  options.programs.ssh-selectivel = {
    enable = mkEnableOption "SSH with selective env vars";
    defaultTerm = mkOption {
      type = types.str;
      default = "xterm-256colors";
    };
    excludeHosts = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig =
        let
          hostPattern =
            if cfg.excludeHosts == [ ]
            then "*"
            else "* " + (concatStringsSep " " (map (h: "!${h}") cfg.excludeHosts));
          envLines = mapAttrsToList (k: v: "    SetEnv ${k}=${v}") cfg.globalSetEnv;
        in
        ''
          Host ${hostPattern}
          ${concatStringsSep "\n" envLines}
        '';
    };
  };
}

