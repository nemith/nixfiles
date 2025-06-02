{ config, pkgs, ... }:
{
  home.shellAliases = {
    kq = "kubectl --context=gke_bluecore-qa-gke_us-central1_qa";
    kp = "kubectl --context=gke_bluecore-prod-gke_us-central1_prod";
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
