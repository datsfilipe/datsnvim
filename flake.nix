{
  description = "datsnvim flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

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

        mkNeovimConfig = { theme ? "default", lazy ? { lock = "default"; } }:
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
          };
      in {
        packages.default = pkgs.lib.makeOverridable mkNeovimConfig {
          theme = "default";
          lazy.lock = "default";
        };
      });
}
