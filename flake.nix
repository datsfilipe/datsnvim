{
  description = "datsnvim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    indentmini-nvim = {
      url = "github:nvimdev/indentmini.nvim";
      flake = false;
    };
    gruvbox-nvim = {
      url = "github:datsfilipe/gruvbox.nvim";
      flake = false;
    };
    min-theme-nvim = {
      url = "github:datsfilipe/min-theme.nvim";
      flake = false;
    };
    vesper-nvim = {
      url = "github:datsfilipe/vesper.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    neovim-nightly-overlay,
    ...
  } @ inputs: let
    defaultConfig = {
      theme = "vesper";
    };
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [neovim-nightly-overlay.overlays.default];
      };

      buildPlug = name: input:
        pkgs.vimUtils.buildVimPlugin {
          pname = name;
          version = "latest";
          src = input;
          doCheck = false;
        };

      configDir = builtins.path {
        path = ./config;
        name = "datsnvim-config";
      };

      configHome = pkgs.linkFarm "datsnvim-config-home" [
        {
          name = "nvim";
          path = configDir;
        }
      ];

      configPlugin = pkgs.stdenv.mkDerivation {
        name = "datsnvim-config";
        src = configDir;
        buildCommand = ''
          mkdir -p $out/share/vim-plugins/datsnvim-config
          cp -r $src/* $out/share/vim-plugins/datsnvim-config/
        '';
      };

      mkNeovimBundle = {theme ? defaultConfig.theme}: let
        configRoot = "${configPlugin}/share/vim-plugins/datsnvim-config";
      in
        pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
          viAlias = true;
          vimAlias = true;
          wrapperArgs = [
            "--set"
            "XDG_CONFIG_HOME"
            "${configHome}"
            "--set"
            "DATSNVIM_THEME"
            "${theme}"
            "--suffix"
            "LIBRARY_PATH"
            ":"
            "${pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc pkgs.zlib]}"
            "--suffix"
            "PKG_CONFIG_PATH"
            ":"
            "${pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" [pkgs.stdenv.cc.cc pkgs.zlib]}"
          ];

          luaRcContent = ''
            vim.opt.runtimepath:prepend("${configHome}/nvim")
            vim.opt.runtimepath:prepend("${configRoot}")
            local init_path = "${configRoot}/init.lua"
            local ok, err = pcall(dofile, init_path)
            if not ok then
              vim.api.nvim_err_writeln(err)
            end
          '';

          plugins =
            [
              configPlugin
            ]
            ++ (with pkgs; [
              vimPlugins.conform-nvim
              vimPlugins.nvim-lspconfig
              vimPlugins.mini-diff
              vimPlugins.mini-pick
              vimPlugins.oil-nvim
              vimPlugins.vim-wakatime
              vimPlugins.nvim-treesitter
              vimPlugins.nvim-lint
              vimPlugins.supermaven-nvim
              vimPlugins.fidget-nvim
              vimPlugins.catppuccin-nvim
              vimPlugins.kanagawa-nvim
            ])
            ++ [
              (buildPlug "indentmini-nvim" inputs.indentmini-nvim)
              (buildPlug "gruvbox-nvim" inputs.gruvbox-nvim)
              (buildPlug "min-theme-nvim" inputs.min-theme-nvim)
              (buildPlug "vesper-nvim" inputs.vesper-nvim)
            ];
        };

      hmModule = {
        config,
        lib,
        pkgs,
        ...
      }:
        with lib; let
          cfg = config.programs.datsnvim;
        in {
          options.programs.datsnvim = {
            enable = mkEnableOption "datsnvim";
            package = mkOption {
              type = types.package;
              default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
              defaultText = literalExpression "datsnvim.packages.${pkgs.stdenv.hostPlatform.system}.default";
            };
            settings = mkOption {
              type = types.submodule {
                options = {
                  theme = mkOption {
                    type = types.str;
                    default = defaultConfig.theme;
                  };
                };
              };
              default = {};
            };
          };
          config = mkIf cfg.enable {
            home.packages = [
              (cfg.package.override cfg.settings)
            ];
          };
        };
    in {
      packages.default = pkgs.lib.makeOverridable mkNeovimBundle defaultConfig;
      homeManagerModules.default = hmModule;
      overlays.default = final: prev: {
        datsnvim = self.packages.${prev.system}.default;
      };
    });
}
