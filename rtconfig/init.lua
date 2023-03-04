-- parse vscode workspace settings

local default_cfg = {
  files = {
    exclude = {
      ["**/.cache/**"] = true,
    },
    trimFinalNewlines = false,
    trimTrailingWhitespace = false,
  },
  editor = {
    formatOnPaste = false,
    formatOnSave = false,
    insertSpaces = false,
    tabSize = 8,
    detectIndentation = false,
    renderWhitespace = "all",
    lineNumbers = "relative",
    rulers = {
      9999,
    },
    suggestOnTriggerCharacters = false,
    guides = {
      indentation = false,
      highlightActiveBracketPair = false,
      highlightActiveIndentation = false,
      bracketPairs = false,
      bracketPairsHorizontal = false,
    },
    inlayHints = {
      enabled = "off",
    },
    wordBasedSuggestions = false,
    quickSuggestions = {
      other = "off",
      comments = "off",
      strings = "off",
    },
    suggest = {
      enabled = false,
      showWords = false,
      showSnippets = true,
      showFiles = true,
      preview = true,
      insertMode = "replace",
      filterGraceful = false,
    },
  }
}

local vsc_cfg_parser = require("custom.rtconfig.vscode")

if vim.g.parse_external_editor_config then
  return vsc_cfg_parser.parse_config(default_cfg)
else
  return default_cfg
end
