local custom_colors = {
  -- base = "#1e1e2e",
  -- blue = "#89b4fa",
  -- crust = "#11111b",
  -- flamingo = "#f2cdcd",
  -- green = "#40a02b",
  -- lavender = "#b4befe",
  -- mantle = "#181825",
  -- maroon = "#eba0ac",
  -- mauve = "#cba6f7",
  -- overlay0 = "#6c7086",
  -- overlay1 = "#7f849c",
  -- overlay2 = "#9399b2",
  -- peach = "#fab387",
  -- pink = "#f5c2e7",
  -- red = "#f38ba8",
  -- rosewater = "#f5e0dc",
  -- sapphire = "#74c7ec",
  -- sky = "#89dceb",
  -- subtext0 = "#a6adc8",
  -- subtext1 = "#bac2de",
  -- surface0 = "#313244",
  -- surface1 = "#45475a",
  -- surface2 = "#585b70",
  -- teal = "#94e2d5",
  -- text = "#cdd6f4",
  -- yellow = "#f9e2af",
  white = "#ffffff",
  black = "#000000",
}

local M = {}

function M.get(opts)
  local colors = vim.deepcopy(custom_colors)
  return colors
end

return M
