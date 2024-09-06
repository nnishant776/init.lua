local spec = {
  enabled = true,
  cond = true,
  dependencies = {
    'lewis6991/gitsigns.nvim',
  },
}

local M = {}

function M.is_enabled(profile, _)
  if profile.level <= 1 then
    return false
  else
    return true
  end
end

function M.setup(profile, editorconfig)
  spec.cond = M.is_enabled(profile, editorconfig)
  if spec.cond then
    vim.api.nvim_create_user_command(
      "GLogl",
      function(cmdargs)
        vim.cmd("Git log --oneline " .. cmdargs.args)
      end,
      { nargs = '*', force = true }
    )
  end
end

function M.spec()
  return spec
end

return M
