{
  description = "datsnvim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }@inputs:
    let
      defaultConfig = {
        theme = "default";
        lazy.lock = "default";
        language-servers = [
          "lua"
          "bash"
          "typescript"
          "rust-analyzer"
          "eslint"
          "json"
          "css"
          "html"
          "go"
        ];
        formatters = [
          "stylua"
          "prettier"
          "biome"
          "alejandra"
        ];
        linters = [
          "codespell"
        ];
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        languageServerPkgs = {
          "lua" = pkgs.lua-language-server;
          "bash" = pkgs.nodePackages.bash-language-server;
          "typescript" = pkgs.nodePackages.typescript-language-server;
          "rust-analyzer" = pkgs.rust-analyzer;
          "eslint" = pkgs.nodePackages.vscode-langservers-extracted;
          "json" = pkgs.nodePackages.vscode-langservers-extracted;
          "css" = pkgs.nodePackages.vscode-langservers-extracted;
          "html" = pkgs.nodePackages.vscode-langservers-extracted;
          "go" = pkgs.gopls;
        };

        formatterPkgs = {
          "stylua" = pkgs.stylua;
          "prettier" = pkgs.nodePackages.prettier;
          "biome" = pkgs.biome;
          "alejandra" = pkgs.alejandra;
        };

        linterPkgs = {
          "codespell" = pkgs.codespell;
        };

        getPackages = mapping: list:
          builtins.map (name: mapping.${name}) list;

        scanPath = dir: ignorePaths:
          let
            shouldIgnore = path:
              builtins.any (ignorePath: 
                builtins.match ignorePath path != null
              ) ignorePaths;

            scan = dir: 
              let
                dirContent = builtins.readDir dir;
                handleEntry = name: type:
                  let path = dir + "/${name}";
                  in
                  if shouldIgnore path then []
                  else if type == "directory" 
                    then scan path
                    else if builtins.match ".*\\.lua$" name != null 
                      then [path]
                      else [];
              in
              builtins.concatLists (
                builtins.attrValues (
                  builtins.mapAttrs handleEntry dirContent
                )
              );
          in
          scan dir;

        mkNeovimConfig = { theme ? defaultConfig.theme
                        , lazy ? { lock = defaultConfig.lazy.lock; }
                        , language-servers ? defaultConfig.language-servers
                        , formatters ? defaultConfig.formatters
                        , linters ? defaultConfig.linters
                        }:
          let
            baseConfig = toString ./.;
            luaFiles = scanPath baseConfig [
              ".*\\.git.*"
              (if theme != "default" then ".*/extensions/colorschemes/init.lua" else "")
              (if lazy.lock != "default" then ".*/extensions/lazy/init.lua" else "")
            ];

            initColoschemes = pkgs.writeText "init.lua" ''
              return ${theme}
            '';
            initLazy = pkgs.writeText "init.lua" ''
              return {
                lock = "${lazy.lock}"
              }
            '';

            requiredPackages = 
              (getPackages languageServerPkgs language-servers) ++
              (getPackages formatterPkgs formatters) ++
              (getPackages linterPkgs linters);

          in pkgs.symlinkJoin rec {
            name = "datsnvim";
            paths = 
              map (file: 
                pkgs.writeTextDir 
                  (builtins.substring (builtins.stringLength (toString baseConfig) + 1) (-1) file)
                  (builtins.readFile file)
              ) luaFiles ++ [
                (if theme != "default" then
                  pkgs.writeTextDir "lua/extensions/colorschemes/init.lua"
                    (builtins.readFile initColoschemes)
                  else null)

                (if lazy.lock != "default" then
                  pkgs.writeTextDir "lua/extensions/lazy/init.lua"
                    (builtins.readFile initLazy)
                  else null)
              ];

            buildInputs = requiredPackages;
          };

        hmModule = { config, lib, pkgs, ... }:
          with lib;
          let
            cfg = config.programs.datsnvim;
          in {
            options.programs.datsnvim = {
              enable = mkEnableOption "datsnvim";

              package = mkOption {
                type = types.package;
                default = self.packages.${pkgs.system}.default;
                defaultText = literalExpression "datsnvim.packages.${pkgs.system}.default";
                description = "The datsnvim package to use";
              };

              settings = mkOption {
                type = types.submodule {
                  options = {
                    theme = mkOption {
                      type = types.str;
                      default = defaultConfig.theme;
                      description = "Theme to use for neovim";
                    };

                    lazy.lock = mkOption {
                      type = types.str;
                      default = defaultConfig.lazy.lock;
                      description = "Lock file configuration for lazy.nvim";
                    };

                    language-servers = mkOption {
                      type = types.listOf (types.enum (builtins.attrNames languageServerPkgs));
                      default = defaultConfig.language-servers;
                      description = "List of language servers to install";
                    };

                    formatters = mkOption {
                      type = types.listOf (types.enum (builtins.attrNames formatterPkgs));
                      default = defaultConfig.formatters;
                      description = "List of formatters to install";
                    };

                    linters = mkOption {
                      type = types.listOf (types.enum (builtins.attrNames linterPkgs));
                      default = defaultConfig.linters;
                      description = "List of linters to install";
                    };
                  };
                };
                default = {};
                description = "Override options for datsnvim";
              };
            };

            config = mkIf cfg.enable {
              home.packages = [ 
                (cfg.package.override cfg.settings)
              ] ++ (getPackages languageServerPkgs cfg.settings.language-servers or defaultConfig.language-servers) ++
                 (getPackages formatterPkgs cfg.settings.formatters or defaultConfig.formatters) ++
                 (getPackages linterPkgs cfg.settings.linters or defaultConfig.linters);
            };
          };

      in {
        packages.default = pkgs.lib.makeOverridable mkNeovimConfig defaultConfig;
        homeManagerModules.default = hmModule;
      });
}
