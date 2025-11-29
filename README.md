<div align="center">

# `DATSNVIM`

This is a personal configuration for Neovim. You can use it as starting point for yours, you can use it as yours, etc. Feel free to use it as you wish at your own risk.

</div>

## Try it out (with [Nix](https://nixos.org/download))

```bash
nix run github:datsfilipe/datsnvim
```

## Headless validation

- Run the config smoke test: `nix run .#default -- --headless -c "lua require('user.modules.healthcheck')"`
- Grab startup time: `nix run .#default -- --headless --startuptime /tmp/startuptime.txt +q`
- Trigger the console from CLI: `nix run .#default -- --headless -c "ConsoleRun echo 'ok'" +qa`

## License

Refer to [LICENSE](./LICENSE).
