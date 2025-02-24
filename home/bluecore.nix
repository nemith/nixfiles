{ config, pkgs, ... }:
{
  home.shellAliases = {
    kq = "kubectl --context=$(kubectx | grep qa)";
    kp = "kubectl --context=$(kubectx | grep prod)";
    kns = "kubens";
    ktx = "kubectx";
  };

  home.packages = with pkgs; [
    slack-cli
    argocd
  ];

  programs.go = {
    goPrivate = [
      "github.com/TriggerMail"
    ];
  };
}
