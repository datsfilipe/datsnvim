#! /usr/bin/env nix-shell
#! nix-shell -i bash -p patchelf

for binary in ${@}
do
  patchelf \
    --set-interpreter "$(cat ${NIX_CC}/nix-support/dynamic-linker)" \
    "${binary}"
done
