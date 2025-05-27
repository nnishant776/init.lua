local spec = {
  enabled = true,
  cond = true,
  opts = {},
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
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
    if not spec.cond then
      return
    end
  end
  spec.opts = {
    heading = {
      -- Useful context to have when evaluating values.
      -- | level    | the number of '#' in the heading marker         |
      -- | sections | for each level how deeply nested the heading is |

      -- Turn on / off heading icon & background rendering.
      enabled = true,
      -- Additional modes to render headings.
      render_modes = false,
      -- Turn on / off atx heading rendering.
      atx = true,
      -- Turn on / off setext heading rendering.
      setext = true,
      -- Turn on / off any sign column related rendering.
      sign = true,
      -- Replaces '#+' of 'atx_h._marker'.
      -- Output is evaluated depending on the type.
      -- | function | `value(context)`              |
      -- | string[] | `cycle(value, context.level)` |
      icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      -- Determines how icons fill the available space.
      -- | right   | '#'s are concealed and icon is appended to right side                          |
      -- | inline  | '#'s are concealed and icon is inlined on left side                            |
      -- | overlay | icon is left padded with spaces and inserted on left hiding any additional '#' |
      position = 'overlay',
      -- Added to the sign column if enabled.
      -- Output is evaluated by `cycle(value, context.level)`.
      signs = { '󰫎 ' },
      -- Width of the heading background.
      -- | block | width of the heading text |
      -- | full  | full width of the window  |
      -- Can also be a list of the above values evaluated by `clamp(value, context.level)`.
      width = 'full',
      -- Amount of margin to add to the left of headings.
      -- Margin available space is computed after accounting for padding.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      -- Can also be a list of numbers evaluated by `clamp(value, context.level)`.
      left_margin = 0,
      -- Amount of padding to add to the left of headings.
      -- Output is evaluated using the same logic as 'left_margin'.
      left_pad = 0,
      -- Amount of padding to add to the right of headings when width is 'block'.
      -- Output is evaluated using the same logic as 'left_margin'.
      right_pad = 0,
      -- Minimum width to use for headings when width is 'block'.
      -- Can also be a list of integers evaluated by `clamp(value, context.level)`.
      min_width = 0,
      -- Determines if a border is added above and below headings.
      -- Can also be a list of booleans evaluated by `clamp(value, context.level)`.
      border = false,
      -- Always use virtual lines for heading borders instead of attempting to use empty lines.
      border_virtual = false,
      -- Highlight the start of the border using the foreground highlight.
      border_prefix = false,
      -- Used above heading for border.
      above = '▄',
      -- Used below heading for border.
      below = '▀',
      -- Highlight for the heading icon and extends through the entire line.
      -- Output is evaluated by `clamp(value, context.level)`.
      backgrounds = {
        'RenderMarkdownH1Bg',
        'RenderMarkdownH2Bg',
        'RenderMarkdownH3Bg',
        'RenderMarkdownH4Bg',
        'RenderMarkdownH5Bg',
        'RenderMarkdownH6Bg',
      },
      -- Highlight for the heading and sign icons.
      -- Output is evaluated using the same logic as 'backgrounds'.
      foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
      },
      -- Define custom heading patterns which allow you to override various properties based on
      -- the contents of a heading.
      -- The key is for healthcheck and to allow users to change its values, value type below.
      -- | pattern    | matched against the heading text @see :h lua-patterns |
      -- | icon       | optional override for the icon                        |
      -- | background | optional override for the background                  |
      -- | foreground | optional override for the foreground                  |
      custom = {},
    },
    code = {
      -- Turn on / off code block & inline code rendering.
      enabled = true,
      -- Additional modes to render code blocks.
      render_modes = false,
      -- Turn on / off any sign column related rendering.
      sign = true,
      -- Determines how code blocks & inline code are rendered.
      -- | none     | disables all rendering                                                    |
      -- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
      -- | language | language icon to sign column if enabled and icon + name above code blocks |
      -- | full     | normal + language                                                         |
      style = 'normal',
      -- Determines where language icon is rendered.
      -- | right | right side of code block |
      -- | left  | left side of code block  |
      position = 'left',
      -- Amount of padding to add around the language.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      language_pad = 0,
      -- Whether to include the language icon above code blocks.
      language_icon = false,
      -- Whether to include the language name above code blocks.
      language_name = false,
      -- A list of language names for which background highlighting will be disabled.
      -- Likely because that language has background highlights itself.
      -- Use a boolean to make behavior apply to all languages.
      -- Borders above & below blocks will continue to be rendered.
      disable_background = { 'diff' },
      -- Width of the code block background.
      -- | block | width of the code block  |
      -- | full  | full width of the window |
      width = 'full',
      -- Amount of margin to add to the left of code blocks.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      -- Margin available space is computed after accounting for padding.
      left_margin = 0,
      -- Amount of padding to add to the left of code blocks.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      left_pad = 0,
      -- Amount of padding to add to the right of code blocks when width is 'block'.
      -- If a float < 1 is provided it is treated as a percentage of available window space.
      right_pad = 0,
      -- Minimum width to use for code blocks when width is 'block'.
      min_width = 0,
      -- Determines how the top / bottom of code block are rendered.
      -- | none  | do not render a border                               |
      -- | thick | use the same highlight as the code body              |
      -- | thin  | when lines are empty overlay the above & below icons |
      -- | hide  | conceal lines unless language name or icon is added  |
      border = 'thin',
      -- Used above code blocks for thin border.
      above = '▄',
      -- Used below code blocks for thin border.
      below = '▀',
      -- Icon to add to the left of inline code.
      inline_left = '',
      -- Icon to add to the right of inline code.
      inline_right = '',
      -- Padding to add to the left & right of inline code.
      inline_pad = 0,
      -- Highlight for code blocks.
      highlight = 'PmenuSel',
      -- Highlight for language, overrides icon provider value.
      highlight_language = nil,
      -- Highlight for border, use false to add no highlight.
      highlight_border = 'PmenuSel',
      -- Highlight for language, used if icon provider does not have a value.
      highlight_fallback = 'NONE',
      -- Highlight for inline code.
      highlight_inline = 'RenderMarkdownCodeInline',
    },
    dash = {
      -- Turn on / off thematic break rendering
      enabled = true,
      -- Replaces '---'|'***'|'___'|'* * *' of 'thematic_break'
      -- The icon gets repeated across the window's width
      icon = '─',
      -- Width of the generated line:
      --  <integer>: a hard coded width value
      --  full:      full width of the window
      width = 'full',
      -- Highlight for the whole line generated from the icon
      highlight = 'RenderMarkdownDash',
    },
    bullet = {
      -- Turn on / off list bullet rendering
      enabled = true,
      -- Replaces '-'|'+'|'*' of 'list_item'
      -- How deeply nested the list is determines the 'level'
      -- The 'level' is used to index into the array using a cycle
      -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
      icons = { '●', '○', '◆', '◇' },
      -- Padding to add to the left of bullet point
      left_pad = 0,
      -- Padding to add to the right of bullet point
      right_pad = 0,
      -- Highlight for the bullet icon
      highlight = 'RenderMarkdownBullet',
    },
    -- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
    -- There are two special states for unchecked & checked defined in the markdown grammar
    checkbox = {
      -- Turn on / off checkbox state rendering
      enabled = true,
      -- Determines how icons fill the available space:
      --  inline:  underlying text is concealed resulting in a left aligned icon
      --  overlay: result is left padded with spaces to hide any additional text
      position = 'inline',
      unchecked = {
        -- Replaces '[ ]' of 'task_list_marker_unchecked'
        icon = '󰄱 ',
        -- Highlight for the unchecked icon
        highlight = 'RenderMarkdownUnchecked',
      },
      checked = {
        -- Replaces '[x]' of 'task_list_marker_checked'
        icon = '󰱒 ',
        -- Highligh for the checked icon
        highlight = 'RenderMarkdownChecked',
      },
      -- Define custom checkbox states, more involved as they are not part of the markdown grammar
      -- As a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks
      -- Can specify as many additional states as you like following the 'todo' pattern below
      --   The key in this case 'todo' is for healthcheck and to allow users to change its values
      --   'raw':       Matched against the raw text of a 'shortcut_link'
      --   'rendered':  Replaces the 'raw' value when rendering
      --   'highlight': Highlight for the 'rendered' icon
      custom = {
        todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
      },
    },
    quote = {
      -- Turn on / off block quote & callout rendering
      enabled = true,
      -- Replaces '>' of 'block_quote'
      icon = '▋',
      -- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text if
      -- not configured correctly with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'. A
      -- combination of these that is likely to work is showbreak = '  ' (2 spaces), breakindent = true,
      -- breakindentopt = '' (empty string). These values are not validated by this plugin. If you want
      -- to avoid adding these to your main configuration then set them in win_options for this plugin.
      repeat_linebreak = false,
      -- Highlight for the quote icon
      highlight = 'RenderMarkdownQuote',
    },
    pipe_table = {
      -- Turn on / off pipe table rendering.
      enabled = true,
      -- Additional modes to render pipe tables.
      render_modes = false,
      -- Pre configured settings largely for setting table border easier.
      -- | heavy  | use thicker border characters     |
      -- | double | use double line border characters |
      -- | round  | use round border corners          |
      -- | none   | does nothing                      |
      preset = 'none',
      -- Determines how the table as a whole is rendered.
      -- | none   | disables all rendering                                                  |
      -- | normal | applies the 'cell' style rendering to each row of the table             |
      -- | full   | normal + a top & bottom line that fill out the table when lengths match |
      style = 'full',
      -- Determines how individual cells of a table are rendered.
      -- | overlay | writes completely over the table, removing conceal behavior and highlights |
      -- | raw     | replaces only the '|' characters in each row, leaving the cells unmodified |
      -- | padded  | raw + cells are padded to maximum visual width for each column             |
      -- | trimmed | padded except empty space is subtracted from visual width calculation      |
      cell = 'padded',
      -- Amount of space to put between cell contents and border.
      padding = 1,
      -- Minimum column width to use for padded or trimmed cell.
      min_width = 0,
      -- Characters used to replace table border.
      -- Correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal.
      -- stylua: ignore
      border = {
        '┌', '┬', '┐',
        '├', '┼', '┤',
        '└', '┴', '┘',
        '│', '─',
      },
      -- Always use virtual lines for table borders instead of attempting to use empty lines.
      -- Will be automatically enabled if indentation module is enabled.
      border_virtual = true,
      -- Gets placed in delimiter row for each column, position is based on alignment.
      alignment_indicator = '━',
      -- Highlight for table heading, delimiter, and the line above.
      head = 'RenderMarkdownTableHead',
      -- Highlight for everything else, main table rows and the line below.
      row = 'RenderMarkdownTableRow',
      -- Highlight for inline padding used to add back concealed space.
      filler = 'RenderMarkdownTableFill',
    },
    callout = {
      -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
      -- The key is for healthcheck and to allow users to change its values, value type below.
      -- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
      -- | rendered   | replaces the 'raw' value when rendering                             |
      -- | highlight  | highlight for the 'rendered' text and quote markers                 |
      -- | quote_icon | optional override for quote.icon value for individual callout       |
      -- | category   | optional metadata useful for filtering                              |

      note      = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo', category = 'github' },
      tip       = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess', category = 'github' },
      important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint', category = 'github' },
      warning   = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn', category = 'github' },
      caution   = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError', category = 'github' },
      -- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
      abstract  = { raw = '[!ABSTRACT]', rendered = '󰨸 Abstract', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
      summary   = { raw = '[!SUMMARY]', rendered = '󰨸 Summary', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
      tldr      = { raw = '[!TLDR]', rendered = '󰨸 Tldr', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
      info      = { raw = '[!INFO]', rendered = '󰋽 Info', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
      todo      = { raw = '[!TODO]', rendered = '󰗡 Todo', highlight = 'RenderMarkdownInfo', category = 'obsidian' },
      hint      = { raw = '[!HINT]', rendered = '󰌶 Hint', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
      success   = { raw = '[!SUCCESS]', rendered = '󰄬 Success', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
      check     = { raw = '[!CHECK]', rendered = '󰄬 Check', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
      done      = { raw = '[!DONE]', rendered = '󰄬 Done', highlight = 'RenderMarkdownSuccess', category = 'obsidian' },
      question  = { raw = '[!QUESTION]', rendered = '󰘥 Question', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
      help      = { raw = '[!HELP]', rendered = '󰘥 Help', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
      faq       = { raw = '[!FAQ]', rendered = '󰘥 Faq', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
      attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn', category = 'obsidian' },
      failure   = { raw = '[!FAILURE]', rendered = '󰅖 Failure', highlight = 'RenderMarkdownError', category = 'obsidian' },
      fail      = { raw = '[!FAIL]', rendered = '󰅖 Fail', highlight = 'RenderMarkdownError', category = 'obsidian' },
      missing   = { raw = '[!MISSING]', rendered = '󰅖 Missing', highlight = 'RenderMarkdownError', category = 'obsidian' },
      danger    = { raw = '[!DANGER]', rendered = '󱐌 Danger', highlight = 'RenderMarkdownError', category = 'obsidian' },
      error     = { raw = '[!ERROR]', rendered = '󱐌 Error', highlight = 'RenderMarkdownError', category = 'obsidian' },
      bug       = { raw = '[!BUG]', rendered = '󰨰 Bug', highlight = 'RenderMarkdownError', category = 'obsidian' },
      example   = { raw = '[!EXAMPLE]', rendered = '󰉹 Example', highlight = 'RenderMarkdownHint', category = 'obsidian' },
      quote     = { raw = '[!QUOTE]', rendered = '󱆨 Quote', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
      cite      = { raw = '[!CITE]', rendered = '󱆨 Cite', highlight = 'RenderMarkdownQuote', category = 'obsidian' },
    },

    link = {
      -- Turn on / off inline link icon rendering
      enabled = true,
      render_modes = false,
      footnote = {
        enabled = true,
        superscript = true,
        prefix = '',
        suffix = '',
      },
      image = '󰥶 ',
      -- Inlined with 'email_autolink' elements
      email = '󰀓 ',
      -- Fallback icon for 'inline_link' elements
      hyperlink = '󰌹 ',
      -- Applies to the fallback inlined icon
      highlight = 'RenderMarkdownLink',
      wiki = {
        icon = '󱗖 ',
        body = function()
          return nil
        end,
        highlight = 'RenderMarkdownWikiLink',
      },
      -- Define custom destination patterns so icons can quickly inform you of what a link
      -- contains. Applies to 'inline_link' and wikilink nodes.
      -- Can specify as many additional values as you like following the 'web' pattern below
      --   The key in this case 'web' is for healthcheck and to allow users to change its values
      --   'pattern':   Matched against the destination text see :h lua-pattern
      --   'icon':      Gets inlined before the link text
      --   'highlight': Highlight for the 'icon'
      custom = {
        web = { pattern = '^http', icon = '󰖟 ' },
        discord = { pattern = 'discord%.com', icon = '󰙯 ' },
        github = { pattern = 'github%.com', icon = '󰊤 ' },
        gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
        google = { pattern = 'google%.com', icon = '󰊭 ' },
        neovim = { pattern = 'neovim%.io', icon = ' ' },
        reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
        stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
        wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
        youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
      },
    },
    sign = {
      -- Turn on / off sign rendering
      enabled = true,
      -- Applies to background of sign text
      highlight = 'RenderMarkdownSign',
    },
    indent = {
      -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
      -- level of the heading. Indenting starts from level 2 headings onward by default.

      -- Turn on / off org-indent-mode.
      enabled = false,
      -- Additional modes to render indents.
      render_modes = false,
      -- Amount of additional padding added for each heading level.
      per_level = 2,
      -- Heading levels <= this value will not be indented.
      -- Use 0 to begin indenting from the very first level.
      skip_level = 1,
      -- Do not indent heading titles, only the body.
      skip_heading = false,
      -- Prefix added when indenting, one per level.
      icon = '▎',
      -- Applied to icon.
      highlight = 'RenderMarkdownIndent',
    },
  }
  spec.config = function(_, opts)
    local is_render_markdown_present, render_markdown = pcall(require, 'render-markdown')
    if not is_render_markdown_present then
      return
    end
    opts = opts or {}
    render_markdown.setup(opts)
  end
end

function M.spec()
  return spec
end

return M
