{
  pkgs,
  lib,
  config,
  ...
}: {
  options.bbennett.k8s = {
    enable = lib.mkEnableOption "k8s tools";
  };

  config = lib.mkIf config.bbennett.k8s.enable {
    home.packages = with pkgs; [
      kubectl
      kubectx
      kubernetes-helm
      kubeswitch
      kustomize
      stern
    ];

    programs.k9s = {
      enable = true;
    };

    programs.kubecolor = {
      enable = true;
      enableAlias = true;
    };

    home.shellAliases = {
      k = "kubectl";
      kctx = "kubectx";
      kns = "kubens";
      ktx = "kubectx";
    };
  };
}
