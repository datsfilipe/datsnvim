{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.datsnvim;
in {
  options.programs.datsnvim = {
    enable = lib.mkEnableOption "datsnvim configuration";

    settings = {
      theme = lib.mkOption {
        type = lib.types.str;
        default = "vesper";
        description = "The theme to use for datsnvim (vesper, gruvbox, min-theme, solarized-osaka, kanagawa, catppuccin)";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;

      extraLuaConfig = ''
        vim.g.datsnvim_theme = "${cfg.settings.theme}"
        ${builtins.readFile ./init.lua}
      '';
    };
  };
}
