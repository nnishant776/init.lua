return {
  update_focused_file = {
    enable = true,
  },
  git = {
    enable = true
  },
  renderer = {
    highlight_git = true,
    root_folder_label = false,
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        git = true,
      },
      glyphs = {
        git = {
          unstaged = "M",
          staged = "S",
          unmerged = "!",
          renamed = "R",
          untracked = "U",
          deleted = "D",
          ignored = "◌",
        }
      }
    },
  },
}
