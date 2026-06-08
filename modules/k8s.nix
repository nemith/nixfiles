_: {
  flake.modules.homeManager.k8s = { pkgs, ... }: {
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
