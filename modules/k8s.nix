_: {
  flake.modules.homeManager.k8s = {pkgs, ...}: {
    home.packages = with pkgs; [
      kubectl
      kubectx
      # doCheck disabled: helm 4.2.0 moved test files to pkg/cmd/ but the
      # darwin preCheck still patches the old cmd/helm/ paths (nixpkgs#532255).
      (kubernetes-helm.overrideAttrs (_: {doCheck = false;}))
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
