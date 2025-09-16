{
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
    ./orbstack.nix
  ];

  networking.hostName = "devvm";

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  users.users.bbennett = {
    uid = 502;
    extraGroups = ["wheel" "orbstack"];

    # simulate isNormalUser, but with an arbitrary UID
    isSystemUser = true;
    group = "users";
    createHome = true;
    home = "/home/bbennett";
    homeMode = "700";
    shell = pkgs.zsh;
  };

  home-manager.users.bbennett = {
    imports = [
      ../../home
      ../../home/personalities/cw.nix
    ];
    home.stateVersion = "25.05";
  };

  security.sudo.wheelNeedsPassword = false;

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = false;

  time.timeZone = "America/Denver";

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  programs.zsh.enable = true;
  programs.bash.enable = true;

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  environment.systemPackages = with pkgs; [
    ghostty.terminfo
  ];

  # Extra certificates from OrbStack.
  security.pki.certificates = [
    ''
            -----BEGIN CERTIFICATE-----
      MIIDqzCCApOgAwIBAgIENTYIajANBgkqhkiG9w0BAQsFADA3MTUwMwYDVQQDEyxD
      b3JlV2VhdmUgSlNTIEJ1aWx0LWluIENlcnRpZmljYXRlIEF1dGhvcml0eTAeFw0y
      MzA3MTEyMDIzMTFaFw0zMzA3MTIyMDIzMTFaMDcxNTAzBgNVBAMTLENvcmVXZWF2
      ZSBKU1MgQnVpbHQtaW4gQ2VydGlmaWNhdGUgQXV0aG9yaXR5MIIBIjANBgkqhkiG
      9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvcE8GRDZiYFVU4m8bwxz3Ev37ei3DBkKSodg
      uNKdrGYRvNKf57dQQdF6LKK9PdcyqXfbIBTMmJvKI92+cFCu62al/uwTkWbZ82ln
      ueoCZUCvGktvIxNaKxDxw8vrgcs78fhwqqeJpQPnYIGkM4953vKceobaRrST0eDC
      Bcx17SBKo0JObagXG4DTIhYingUAcNy7qgeu3+s2OwgzAxNk4c5j6yrgqreLVn63
      dU2MnDM2cGx/Tod7IDzTPdDZ73x45b9feZHWM7ce15AcgdbwGs2p4krwWBwxTfZq
      UHT+5MssqXPsw7nMhM0XjzimDfsneoX/wEZV8hnPlZ1elXFY8wIDAQABo4G+MIG7
      MB0GA1UdDgQWBBQgwAEqDtCJNPPPyzS5Q+6t/FexIzATBgNVHSUEDDAKBggrBgEF
      BQcDATAOBgNVHQ8BAf8EBAMCAaYwDwYDVR0TAQH/BAUwAwEB/zBDBgNVHR8EPDA6
      MDigNqA0hjJodHRwczovL2NvcmV3ZWF2ZS5qYW1mY2xvdWQuY29tLy9DQS9KQU1G
      Q1JMU2VydmxldDAfBgNVHSMEGDAWgBQgwAEqDtCJNPPPyzS5Q+6t/FexIzANBgkq
      hkiG9w0BAQsFAAOCAQEALaZCS/+G8A3hA5Ic74m8UR6VLl+8ggurV7dcKx5DRPKp
      LVApkNJnyxCXTqpyG4oiSgNUvqot9UAj6SuOzgiQbKTqFn2Dsvyq0ngYTONjKlgn
      852lXIkK8btP5Dg4CGrRiVEldTxQJJLgilyo8T5nCrrq55tGMXMQclnOHnAsypb/
      du1Rnpbc463RncA9zlZNvHPnvlHsAbT5fqVkDeZPPyRPTAxYiygWQuQrr6A6cUma
      otjKLjQveTJ2lkZChZvJM4K//iu5nIFOmK89nldicOunKzAzUVYlxpQ6oC2mJYQH
      2knu7kGpm55AVRyPFRPK8CjFajVIGgFLutmJJXbv3A==
      -----END CERTIFICATE-----

      -----BEGIN CERTIFICATE-----
      MIIB4zCCAYmgAwIBAgIUfH4YMqC8IV/OX9WatQxSJSegYOcwCgYIKoZIzj0EAwIw
      ZzEaMBgGA1UEAwwRY29yZXdlYXZlLnByb3RlY3QxDTALBgNVBAoMBEphbWYxOjA4
      BgNVBAsMMUphbWYgUHJvdGVjdCA5MTdjMGFhNS1lYjZiLTQwZjYtYmI1NC1lYzRm
      OTg2NjJhNWIwHhcNMjMwODE2MjEzNzAzWhcNNDMwODExMjEzNzAzWjBnMRowGAYD
      VQQDDBFjb3Jld2VhdmUucHJvdGVjdDENMAsGA1UECgwESmFtZjE6MDgGA1UECwwx
      SmFtZiBQcm90ZWN0IDkxN2MwYWE1LWViNmItNDBmNi1iYjU0LWVjNGY5ODY2MmE1
      YjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABLjvC9PPHcAAbjnpVcZWAsKRzN9Z
      C/Jgl30Ms9v73aRDriYOrV1cwzj1WWAx74ttvrgR7gv7QMHijv1ka9Y/w8ejEzAR
      MA8GA1UdEwEB/wQFMAMBAf8wCgYIKoZIzj0EAwIDSAAwRQIgHvDd7eBahsEULZIg
      RgJBSM3zgM4cV/Y57ISF21Q+GfcCIQCZLhOhhoPucZ9yz5uj40SkAhaHya64oydR
      IP+WFCOQug==
      -----END CERTIFICATE-----

      -----BEGIN CERTIFICATE-----
      MIID+TCCAuGgAwIBAgICAVcwDQYJKoZIhvcNAQELBQAwgZQxJTAjBgkqhkiG9w0B
      CQEMFmNlcnRhZG1pbkBuZXRza29wZS5jb20xEjAQBgNVBAMMCWNlcnRhZG1pbjES
      MBAGA1UECwwJY2VydGFkbWluMRYwFAYDVQQKDA1OZXRza29wZSBJbmMuMREwDwYD
      VQQHDAhTYW4gSm9zZTELMAkGA1UECAwCQ0ExCzAJBgNVBAYMAlVTMB4XDTIyMDUx
      MjIyNDg0MloXDTMyMDUwOTIyNDg0MlowgZQxJTAjBgkqhkiG9w0BCQEMFmNlcnRh
      ZG1pbkBuZXRza29wZS5jb20xEjAQBgNVBAMMCWNlcnRhZG1pbjESMBAGA1UECwwJ
      Y2VydGFkbWluMRYwFAYDVQQKDA1OZXRza29wZSBJbmMuMREwDwYDVQQHDAhTYW4g
      Sm9zZTELMAkGA1UECAwCQ0ExCzAJBgNVBAYMAlVTMIIBIjANBgkqhkiG9w0BAQEF
      AAOCAQ8AMIIBCgKCAQEAq9u+p3tH2OaXIai2hiWFFu81G3QH+lAW9H29BX/emqdK
      U7xD0Wc52TOLALDZos3p3hTOeQMIaC5cCrqUbtE9V4gmtceUFJ/bD/lHlVtQZKl4
      HcsRAek8cmwIf3bWkeih9XjzbEYY7ffq5ifkT10OENqzrZO9RryDXQnBB6tALB/I
      MY4JEFzK9Vr8eqLdKHEfCAjAsvU2HePOZXImrPEFcttgOsoGTsC98Jk2JKMlsme0
      mH136MPhKa54ZrFhNRx/jLogNB+EsWlDeWD78tjlNBTGuX5QAVcBeoijrlMUX4k7
      cf++fJgUdZSz2k75LEuBMn4pd6sPDsJ5dWppzCMx4QIDAQABo1MwUTAPBgNVHRMB
      Af8EBTADAQH/MB0GA1UdDgQWBBQVt3Q8rBQqDyEKxxubOEQ84txBTDAfBgNVHSME
      GDAWgBQVt3Q8rBQqDyEKxxubOEQ84txBTDANBgkqhkiG9w0BAQsFAAOCAQEAFUpG
      UV6iM7N9GQpkW2bGdPr0aobsxAxlFeMS3I6dDrrlTvAqAxmMpxHa4X9ghUybHU8M
      6PahBA4K4hJsO5fr6u5HBvvomd6Qad6Ks9DLmhuEBlrj4cRoWyfmGVG0OiObeG8a
      QJqEmd3wv3ajn1VFif2s2JGVWpGE7/LJKQcNwbIlVycq++5kjF1sc+RpOCQCSq7G
      LMpX5aOQr+KY7I7nCK01OgVDvhf3amRA5ZvgisSREMah+qqjm3u9jj3LMzpOzJkK
      6U6Y+TDV1xaumxhTBk7BkbC5spBZfVv8+CA/pv/G8hRvrq++jSJvbWXvz8m5lFT0
      CivcxSKMW68x8vGHbQ==
      -----END CERTIFICATE-----

      -----BEGIN CERTIFICATE-----
      MIIELDCCAxSgAwIBAgIEAoYMrjANBgkqhkiG9w0BAQsFADCBrjELMAkGA1UEBhMC
      VVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFyYTEVMBMGA1UEChMM
      bmV0U2tvcGUgSW5jMRgwFgYDVQQLEw9DZXJ0IE1hbmFnZW1lbnQxJDAiBgNVBAMT
      G2Vwcm94eS5jYWFkbWluLm5ldHNrb3BlLmNvbTElMCMGCSqGSIb3DQEJARYWY2Vy
      dGFkbWluQG5ldHNrb3BlLmNvbTAeFw0yMDEwMTUxNzQzMTVaFw0zMDEwMTMxNzQz
      MTVaMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFDASBgNVBAcTC1NhbnRh
      IENsYXJhMRUwEwYDVQQKEwxuZXRTa29wZSBJbmMxGDAWBgNVBAsTD0NlcnQgTWFu
      YWdlbWVudDEkMCIGA1UEAxMbZXByb3h5LmNhYWRtaW4ubmV0c2tvcGUuY29tMSUw
      IwYJKoZIhvcNAQkBFhZjZXJ0YWRtaW5AbmV0c2tvcGUuY29tMIIBIjANBgkqhkiG
      9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwsLcy+ib9RN4ZJ+3UuTANK6eaYTmpBh3Ie/B
      ywO+At2sXsxEhZwhdaTAy0h77rJRpFJxOBFm0k14VSKtXnsr5jfM14nJrzmE3ZF3
      ISLV0kl1wTGi5lxXAJ7ywUDxjY7l6K1uU1KdeQ9KFaMCc9odn5bZSRAxCh3PfmSp
      FNq8SUmaiaX+Jlv1N+P2kmW9aXgFm6KSuqZq0i4FwTOUGpJDlMY3N/L4LbZju9/z
      3qhgp4HWO2m8GHHZaisfqve+kbMLSfQzcavXFHlynyiZcnyyTaCGxakVSGhi0Ve8
      oJMyqf9p1+WuN0wwS98uVdb4EP05IFKe1sQjIiCCoBL/u9OeZQIDAQABo1AwTjAM
      BgNVHRMEBTADAQH/MB0GA1UdDgQWBBTZ5htfQe6cvE1easQeTnn2BRIC6jAfBgNV
      HSMEGDAWgBTZ5htfQe6cvE1easQeTnn2BRIC6jANBgkqhkiG9w0BAQsFAAOCAQEA
      hXw13kc38z+YWbMxLAHBClvJQlT9Q/NaOfIdTY7+0NjltlzOozhGrniuUF7L3Cvt
      NGw4nj3PkB3xHXcfSWasJlMJkeRInYdCckBbT8eUIoxsUgRykxoINksIJPhsgkeZ
      /4xGLHyCr6nQjzlgdniMAqpMGnItbVuzNL8ChdiKY3BleuXD+HA+5GJ9nnu4uYwq
      1Fa/SwRIXgsfhCcTpy8FfjTgcw9Zs02AKEfrxGzWFCOmp1yvUrt2iyrSGxpEI8oq
      DbtWnoQOl0ugPzEaqEaIlwahStW8FPh5+7ovjPDUlRtf0HtYKDGO8tN8IRYBM+jb
      rZtvx6HaRh0vrIwKOBEnDQ==
      -----END CERTIFICATE-----

      -----BEGIN CERTIFICATE-----
      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
      -----END CERTIFICATE-----

      -----BEGIN CERTIFICATE-----
      MIICDDCCAbKgAwIBAgIQAvy0Nql37Ee7P3+i1YliHTAKBggqhkjOPQQDAjBmMR0w
      GwYDVQQKExRPcmJTdGFjayBEZXZlbG9wbWVudDEeMBwGA1UECwwVQ29udGFpbmVy
      cyAmIFNlcnZpY2VzMSUwIwYDVQQDExxPcmJTdGFjayBEZXZlbG9wbWVudCBSb290
      IENBMB4XDTI1MDcxNjAzNTkyMVoXDTM1MDcxNjAzNTkyMVowZjEdMBsGA1UEChMU
      T3JiU3RhY2sgRGV2ZWxvcG1lbnQxHjAcBgNVBAsMFUNvbnRhaW5lcnMgJiBTZXJ2
      aWNlczElMCMGA1UEAxMcT3JiU3RhY2sgRGV2ZWxvcG1lbnQgUm9vdCBDQTBZMBMG
      ByqGSM49AgEGCCqGSM49AwEHA0IABN1Ljh3XXo7rkzlI/HLxnPRqtze1bPlElNpd
      hONqu3pWoXyAXilGga115esJBGrkESM3FUrNHe8sVm2gSfnEpp+jQjBAMA4GA1Ud
      DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTl53awAxi3jBSI
      6nASpa9yEYXoyzAKBggqhkjOPQQDAgNIADBFAiBXQ2l4r02cpCrvJm4vgAyKg+EF
      PtbPKVDOQ307MBEUswIhAJ3ZRZZpwN2hrPXbmZPD+GqD/v92IO2BkGRd+JjwvRh1
      -----END CERTIFICATE-----

    ''
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}
