{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.neovim = inputs.wrappers.wrappers.neovim.wrap (
      { wlib, config, ... }: {
        inherit pkgs;

        settings.config_directory = ./.;
        settings.aliases = [
          "vim"
          "vi"
        ];

        specs.startup = with pkgs.vimPlugins; [
          lze
          lzextras
          catppuccin-nvim
        ];

        specs.general = {
          lazy = true;
          after = [ "startup" ];

          runtimePkgs = with pkgs; [
            lua-language-server
            stylua
            nixd
            gopls
            rust-analyzer
            imagemagick
          ];

          data = with pkgs.vimPlugins; [
            # Core UI
            (pkgs.vimUtils.buildVimPlugin {
              pname = "agent-term.nvim";
              version = "unstable-2026-07-23";
              src = pkgs.fetchFromGitHub {
                owner = "alsi-lawr";
                repo = "agent-term.nvim";
                rev = "14b751732cce7c4c3f7cfca6b2f20b33f4dc1f1c";
                hash = "sha256-yGth9Mf+rhn2RIJ+FAKFvWtmA5jezpt1kc8uk1Zu7fc=";
              };
            })
            guess-indent-nvim
            gitsigns-nvim
            which-key-nvim
            todo-comments-nvim
            mini-nvim
            snacks-nvim
            bufferline-nvim
            diffview-nvim
            persistence-nvim

            # LSP
            nvim-lspconfig
            lazydev-nvim

            # Formatting
            conform-nvim

            # Completion & Snippets
            blink-cmp
            luasnip

            # Treesitter (used for grammars only)
            nvim-treesitter.withAllGrammars

            nvim-web-devicons

            # ai
            copilot-lua
          ];
        };

        specMods = _: {
          options.runtimePkgs = lib.mkOption {
            type = lib.types.listOf wlib.types.stringable;
            default = [ ];
          };
        };
        runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];
      }
    );
  };

  flake.modules.homeManager.neovim = { pkgs, ... }: {
    home.sessionVariables.EDITOR = "nvim";
    home.shellAliases.nvim-unwrapped = "${pkgs.neovim-unwrapped}/bin/nvim";
    home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
  };
}
