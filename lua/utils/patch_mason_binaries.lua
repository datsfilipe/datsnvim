local M = {}

function M.patch(pkg)
  pkg:get_receipt():if_present(function(receipt)
    for _, rel_path in pairs(receipt.links.bin) do
      local bin_abs_path = pkg:get_install_path() .. '/' .. rel_path
      if pkg.name == 'lua-language-server' then
        bin_abs_path = pkg:get_install_path() .. '/extension/server/bin/lua-language-server'
      end

      os.execute(script_dir .. 'nixos_patch_mason.sh ' .. bin_abs_path)
    end
  end)
end

return M
