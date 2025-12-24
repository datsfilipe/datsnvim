{
  description = "datsnvim flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = {
    nixpkgs,
    neovim-nightly-overlay,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [neovim-nightly-overlay.overlays.default];
    };
  in {
    homeManagerModules.default = {pkgs, ...}: {
      imports = [./module.nix];
      programs.neovim.package = neovim-nightly-overlay.packages.${pkgs.system}.default;
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        lua-language-server
        stylua
        nil
        alejandra
        (writeShellScriptBin "vim" ''
          exec ${pkgs.neovim}/bin/nvim "$@"
        '')
      ];

      shellHook = ''
        export XDG_CONFIG_HOME="$PWD"
        export XDG_DATA_HOME="$PWD/.data"
        export XDG_STATE_HOME="$PWD/.state"
        export GIT_CONFIG_GLOBAL="$HOME/.config/git/config"
      '';
    };
  };
}
