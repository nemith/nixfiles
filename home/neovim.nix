{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (inputs.nixCats) utils;
in {
  imports = [
    inputs.nixCats.homeModule
  ];

  options.bbennett.neovim.enable = lib.mkEnableOption "Neovim configuration for bbennett";

  config = lib.mkIf config.bbennett.neovim.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    nixCats = {
      enable = true;

      addOverlays =
        /*
        (import ./overlays inputs) ++
        */
        [
          (utils.standardPluginOverlay inputs)
        ];

      packageNames = ["bbennettNeovim"];

      luaPath = ./configs/nvim;

      categoryDefinitions.replace = {pkgs, ...}: {
        lspsAndRuntimeDeps = {
          general = with pkgs; [
            lazygit
          ];

          lua = with pkgs; [
            lua-language-server
            stylua
          ];

          nix = with pkgs; [
            nixd
            alejandra
          ];

          go = with pkgs; [
            gopls
            delve
            golangci-lint
            gotools
            go-tools
            go
          ];
        };

        startupPlugins = {
          general = with pkgs.vimPlugins; [
            config.catppuccin.sources.nvim
            lze
            lzextras
            snacks-nvim
            onedark-nvim
            vim-sleuth
          ];
        };

        optionalPlugins = {
          general = with pkgs.vimPlugins; [
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
          ];

          lua = with pkgs.vimPlugins; [
            lazydev-nvim
          ];

          go = with pkgs.vimPlugins; [
            nvim-dap-go
          ];
        };
      };

      packageDefinitions.replace = {
        bbennettNeovim = _: {
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            aliases = ["nvim" "vim" "vi"];
          };

          categories = {
            general = true;
            lua = true;
            nix = true;
            go = true;
          };
        };
      };
    };
  };
}
