{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.neovim = inputs.wrappers.wrappers.neovim.wrap (
      {
        wlib,
        config,
        ...
      }: {
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
          after = ["startup"];

          runtimePkgs = with pkgs; [
            lua-language-server
            stylua
            nixd
            gopls
            rust-analyzer
            claude-code
            imagemagick
          ];

          data = with pkgs.vimPlugins; [
            # Core UI
            guess-indent-nvim
            gitsigns-nvim
            which-key-nvim
            todo-comments-nvim
            mini-nvim
            snacks-nvim
            bufferline-nvim
            diffview-nvim
            persistence-nvim
            multicursor-nvim

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

            # neo tree
            neo-tree-nvim
            nui-nvim
            nvim-web-devicons

            # ai
            claudecode-nvim
            copilot-lua
          ];
        };

        specMods = _: {
          options.runtimePkgs = lib.mkOption {
            type = lib.types.listOf wlib.types.stringable;
            default = [];
          };
        };
        runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [])) [];
      }
    );
  };

  flake.modules.homeManager.neovim = {pkgs, ...}: {
    home.sessionVariables.EDITOR = "nvim";
    home.shellAliases.nvim-unwrapped = "${pkgs.neovim-unwrapped}/bin/nvim";
    home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.neovim];
  };
}
