{ self, inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      packages.neovim = inputs.wrappers.wrappers.neovim.wrap (
        { wlib, config, ... }:
        {
          inherit pkgs;

          settings.config_directory = ./lua;
          settings.aliases = [
            "vim"
            "vi"
          ];

          specs.startup = with pkgs.vimPlugins; [
            catppuccin-nvim
            lze
            lzextras
            snacks-nvim
            onedark-nvim
            vim-sleuth
          ];

          specs.general = {
            lazy = true;
            after = [ "startup" ];

            extraPackages = with pkgs; [
              lazygit
              lua-language-server
              stylua
              nixd
              alejandra
              gopls
              delve
              golangci-lint
              gotools
              go-tools
              go
            ];

            data = with pkgs.vimPlugins; [
              mini-nvim
              nvim-lspconfig
              vim-startuptime
              blink-cmp
              nvim-treesitter.withAllGrammars
              lualine-nvim
              lualine-lsp-progress
              gitsigns-nvim
              which-key-nvim
              nvim-lint
              conform-nvim
              nvim-dap
              nvim-dap-ui
              nvim-dap-virtual-text
              lazydev-nvim
              nvim-dap-go
            ];
          };

          specMods = _: {
            options.extraPackages = lib.mkOption {
              type = lib.types.listOf wlib.types.stringable;
              default = [ ];
            };
          };
          extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [ ])) [ ];
        }
      );
    };

  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      home.sessionVariables.EDITOR = "nvim";
      home.shellAliases.nvim-unwrapped = "${pkgs.neovim-unwrapped}/bin/nvim";
      home.packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.neovim ];
    };
}
