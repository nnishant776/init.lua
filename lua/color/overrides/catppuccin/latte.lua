local custom_colors = {
  -- base = "#eff1f5",
  -- blue = "#1e66f5",
  -- crust = "#dce0e8",
  -- flamingo = "#dd7878",
  -- green = "#40a02b",
  -- lavender = "#7287fd",
  -- mantle = "#e6e9ef",
  -- maroon = "#e64553",
  -- mauve = "#8839ef",
  -- overlay0 = "#9ca0b0",
  -- overlay1 = "#8c8fa1",
  -- overlay2 = "#7c7f93",
  -- peach = "#fe640b",
  -- pink = "#ea76cb",
  -- red = "#d20f39",
  -- rosewater = "#dc8a78",
  -- sapphire = "#209fb5",
  -- sky = "#04a5e5",
  -- subtext0 = "#6c6f85",
  -- subtext1 = "#5c5f77",
  -- surface0 = "#ccd0da",
  -- surface1 = "#bcc0cc",
  -- surface2 = "#acb0be",
  -- teal = "#179299",
  -- text = "#4c4f69",
  -- yellow = "#df8e1d",
  white = "#ffffff",
  black = "#000000",
}

local M = {}

function M.get(opts)
  local colors = vim.deepcopy(custom_colors)
  colors.base = colors.white
  return colors
end

return M
