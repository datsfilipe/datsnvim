{
  config,
  lib,
  ...
}: let
  cfg = config.programs.datsnvim;

  nvimFiles = builtins.readDir ./nvim;

  nvimLinks = lib.mapAttrs' (
    name: _:
      lib.nameValuePair "nvim/${name}" {source = ./nvim + "/${name}";}
  ) (lib.filterAttrs (n: _: n != "init.lua" && n != "nvim-pack-lock.json") nvimFiles);
in {
  options.programs.datsnvim = {
    enable = lib.mkEnableOption "datsnvim configuration";
    settings = {
      theme = lib.mkOption {
        type = lib.types.str;
        default = "vesper";
        description = "The theme to use for datsnvim";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = nvimLinks;

    programs.neovim = {
      enable = true;

      extraLuaConfig = ''
        vim.g.datsnvim_theme = "${cfg.settings.theme}"
        ${builtins.readFile ./nvim/init.lua}
      '';
    };

    home.activation.copyDatsnvimLock = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run rm -f $HOME/.config/nvim/nvim-pack-lock.json
      if [ -f "${./nvim/nvim-pack-lock.json}" ]; then
        verboseEcho "Copying writable nvim-pack-lock.json..."
        run cp -f "${./nvim/nvim-pack-lock.json}" "$HOME/.config/nvim/nvim-pack-lock.json"
        run chmod u+w "$HOME/.config/nvim/nvim-pack-lock.json"
      fi
    '';
  };
}
