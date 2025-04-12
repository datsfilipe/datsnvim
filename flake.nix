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

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
  } @ inputs: let
    defaultConfig = {
      theme = "default";
      lazy.lock = "default";
    };
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      getPackages = mapping: list:
        builtins.map (name: mapping.${name}) list;

      scanPath = dir: ignorePaths: let
        shouldIgnore = path:
          builtins.any (
            ignorePath:
              builtins.match ignorePath path != null
          )
          ignorePaths;

        scan = dir: let
          dirContent = builtins.readDir dir;
          handleEntry = name: type: let
            path = dir + "/${name}";
          in
            if shouldIgnore path
            then []
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

      mkNeovimConfig = {
        theme ? defaultConfig.theme,
        lazy ? {lock = defaultConfig.lazy.lock;},
      }: let
        baseConfig = toString ./.;
        luaFiles = scanPath baseConfig [
          ".*\\.git.*"
          (
            if theme != "default"
            then ".*/extensions/colorschemes/init.lua"
            else ""
          )
          (
            if lazy.lock != "default"
            then ".*/extensions/lazy/init.lua"
            else ""
          )
        ];

        initColoschemes = pkgs.writeText "init.lua" ''
          return "${theme}"
        '';
        initLazy = pkgs.writeText "init.lua" ''
          return {
            lock = "${lazy.lock}"
          }
        '';
      in
        pkgs.symlinkJoin rec {
          name = "datsnvim";
          paths =
            map (
              file:
                pkgs.writeTextDir
                (builtins.substring (builtins.stringLength (toString baseConfig) + 1) (-1) file)
                (builtins.readFile file)
            )
            luaFiles
            ++ [
              (
                if theme != "default"
                then
                  pkgs.writeTextDir "lua/extensions/colorschemes/init.lua"
                  (builtins.readFile initColoschemes)
                else null
              )

              (
                if lazy.lock != "default"
                then
                  pkgs.writeTextDir "lua/extensions/lazy/init.lua"
                  (builtins.readFile initLazy)
                else null
              )
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
                };
              };
              default = {};
              description = "Override options for datsnvim";
            };
          };

          config = mkIf cfg.enable {
            home.packages = [
              (cfg.package.override cfg.settings)
            ];

            xdg.configFile."nvim" = {
              source = cfg.package.override cfg.settings;
              recursive = true;
            };
          };
        };
    in {
      packages.default = pkgs.lib.makeOverridable mkNeovimConfig defaultConfig;
      homeManagerModules.default = hmModule;
      overlays.default = final: prev: {
        datsnvim = self.packages.${prev.system}.default;
      };
    });
}
