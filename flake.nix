{
  description = "datsnvim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hlchunk = {
      url = "github:shellRaining/hlchunk.nvim";
      flake = false;
    };
    wakatime = {
      url = "github:wakatime/vim-wakatime";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, hlchunk, wakatime }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        hlchunk-nvim = pkgs.vimUtils.buildVimPlugin {
          name = "hlchunk-nvim";
          src = hlchunk;
        };
        
        vim-wakatime = pkgs.vimUtils.buildVimPlugin {
          name = "vim-wakatime";
          src = wakatime;
        };

        pluginMappings = {
          "minidiff" = {
            dir = "${pkgs.vimPlugins.mini-diff}";
            name = "mini.diff";
            path = ./lua/plugins/minidiff.lua;
          };
          "ministatusline" = {
            dir = "${pkgs.vimPlugins.mini-statusline}";
            name = "mini.statusline";
            path = ./lua/plugins/ministatusline.lua;
          };
          "minipick" = {
            dir = "${pkgs.vimPlugins.mini-pick}";
            name = "mini.pick";
            path = ./lua/plugins/minipick.lua;
          };
          "minigit" = {
            dir = "${pkgs.vimPlugins.mini-git}";
            name = "mini.git";
            path = ./lua/plugins/minigit.lua;
          };
          "minihipatterns" = {
            dir = "${pkgs.vimPlugins.mini-hipatterns}";
            name = "mini.hipatterns";
            path = ./lua/plugins/minihipatterns.lua;
          };
          "nvim_lint" = {
            dir = "${pkgs.vimPlugins.nvim-lint}";
            name = "nvim-lint";
            path = ./lua/plugins/nvim_lint.lua;
          };
          "conform" = {
            dir = "${pkgs.vimPlugins.conform-nvim}";
            name = "conform";
            path = ./lua/plugins/conform.lua;
          };
          "oil" = {
            dir = "${pkgs.vimPlugins.oil-nvim}";
            name = "oil";
            path = ./lua/plugins/oil.lua;
          };
          "render_markdown" = {
            dir = "${pkgs.vimPlugins.render-markdown-nvim}";
            name = "render-markdown";
            path = ./lua/plugins/render_markdown.lua;
          };
          "supermaven" = {
            dir = "${pkgs.vimPlugins.supermaven-nvim}";
            name = "supermaven";
            path = ./lua/plugins/supermaven.lua;
          };
          "treesitter" = {
            dir = "${pkgs.vimPlugins.nvim-treesitter}";
            name = "nvim-treesitter";
            path = ./lua/plugins/treesitter.lua;
          };
          "nvim_lspconfig" = {
            dir = "${pkgs.vimPlugins.nvim-lspconfig}";
            name = "nvim-lspconfig";
            path = ./lua/plugins/nvim_lspconfig/init.lua;
          };
          "fidget" = {
            dir = "${pkgs.vimPlugins.fidget-nvim}";
            name = "fidget";
            path = ./lua/plugins/fidget.lua;
          };
          "blink" = {
            dir = "${pkgs.vimPlugins.blink-cmp}";
            name = "blink";
            path = ./lua/plugins/blink.lua;
          };
          "harpoon2" = {
            dir = "${pkgs.vimPlugins.harpoon2}";
            name = "harpoon2";
            path = ./lua/plugins/harpoon2.lua;
          };
          "hlchunk" = {
            dir = "${hlchunk-nvim}";
            name = "hlchunk";
            path = ./lua/plugins/hlchunk.lua;
          };
          "vim_wakatime" = {
            dir = "${vim-wakatime}";
            name = "vim-wakatime";
            path = ./lua/plugins/wakatime.lua;
          };
        };
        
        getPluginContent = name: path:
          let 
            content = builtins.readFile path;
            lines = pkgs.lib.splitString "\n" content;
          in
          pkgs.lib.concatStringsSep "\n" (pkgs.lib.drop 2 lines);

        flakeModule = pkgs.writeText "flake.lua" ''
          local M = {}
          
          M.specs = {
          ${builtins.concatStringsSep "\n" (builtins.attrValues (builtins.mapAttrs (name: value: ''
            ${name} = {
              dir = '${value.dir}',
              name = '${value.name}',
              ${getPluginContent name value.path}
          '') pluginMappings))}
          }
          
          return M
        '';

        initSpec = pkgs.writeText "init.lua" ''
          return require 'extensions.specs.flake'
        '';
        initTheme = theme: pkgs.writeText "init.lua" ''
          return ${theme}
        '';
        initLazy = lockfile: pkgs.writeText "init.lua" ''
          return {
            lock = ${lockfile}
          }
        '';
        
        mkNeovimConfig = { theme ? "default", lazy ? { lock = "default"; } }:
          pkgs.symlinkJoin {
            name = "neovim-config";
            paths = [
              (pkgs.writeTextDir "lua/extensions/specs/flake.lua" 
                (builtins.readFile flakeModule))
              (pkgs.writeTextDir "lua/extensions/specs/init.lua"
                (builtins.readFile initSpec))
              (if theme != "default" then pkgs.writeTextDir "lua/extensions/colorschemes/init.lua"
                (builtins.readFile (initTheme theme)) else "")
              (if lazy.lock != "default" then pkgs.writeTextDir "lua/extensions/lazy/init.lua"
                (builtins.readFile (initLazy lazy.lock)) else "")
              ./.
            ];
          };
      in {
        packages.default = pkgs.lib.makeOverridable mkNeovimConfig {
          theme = "default";
          lazy.lock = "default";
        };
      });
}
