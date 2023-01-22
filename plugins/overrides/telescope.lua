return {
  defaults = {
    initial_mode = "normal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.60,
        results_width = 0.40,
      },
      vertical = {
        mirror = false,
      },
      width = 0.90,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_ignore_patterns = { "node_modules" },
  },
}
