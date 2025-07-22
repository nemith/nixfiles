{ pkgs
, lib
, config
, ...
}:
{
  options = {
    bbennett.k8s.enable = lib.mkEnableOption "k8s tools";
  };

  config = lib.mkIf config.bbennett.dev.enable {
    home.packages = with pkgs; [
      kubernetes-helm
      kubectl
      kubectx
      kubeswitch
      kustomize
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
