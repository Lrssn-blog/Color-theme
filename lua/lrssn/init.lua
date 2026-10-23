-- The Lrssn colour themes for Neovim: Lrssn Hearth and Lrssn Shore.
--
-- The colours come from lua/lrssn/palettes.lua, which scripts/build.py
-- generates from palette/. This file maps the roles of a palette to the
-- highlight groups of Neovim, of Treesitter, of the LSP and of the plugins
-- that LazyVim installs by default.
local M = {}

-- The terminal colours, in the order of `g:terminal_color_0` to 15.
local ANSI = {
  'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white',
  'bright_black', 'bright_red', 'bright_green', 'bright_yellow',
  'bright_blue', 'bright_magenta', 'bright_cyan', 'bright_white',
}

--- Returns the palette of a theme, such as 'lrssn-hearth'.
---@param name string
---@return table
function M.palette(name)
  local palette = require('lrssn.palettes')[name]
  if not palette then
    error('lrssn: there is no theme called ' .. name)
  end
  return palette
end

--- Returns the highlight groups for a palette, as {group: spec}.
---@param p table
---@return table<string, table>
function M.highlights(p)
  -- `function` is a Lua keyword, so it has no field syntax.
  local fn = p['function']
  return {
    -- The editor.
    Normal = { fg = p.fg, bg = p.bg },
    NormalNC = { fg = p.fg, bg = p.bg },
    NormalFloat = { fg = p.fg, bg = p.bg_raised },
    FloatBorder = { fg = p.border, bg = p.bg_raised },
    FloatTitle = { fg = p.primary_text, bg = p.bg_raised, bold = true },
    ColorColumn = { bg = p.bg_line },
    Conceal = { fg = p.fg_subtle },
    Cursor = { fg = p.bg, bg = p.accent },
    lCursor = { link = 'Cursor' },
    CursorIM = { link = 'Cursor' },
    TermCursor = { fg = p.bg, bg = p.accent },
    CursorLine = { bg = p.bg_line },
    CursorColumn = { bg = p.bg_line },
    CursorLineNr = { fg = p.accent, bold = true },
    LineNr = { fg = p.fg_subtle },
    SignColumn = { bg = p.bg },
    FoldColumn = { fg = p.fg_subtle, bg = p.bg },
    Folded = { fg = p.fg_muted, bg = p.bg_line },
    Directory = { fg = p.type },
    EndOfBuffer = { fg = p.bg },
    ErrorMsg = { fg = p.error },
    WarningMsg = { fg = p.warning },
    ModeMsg = { fg = p.fg_muted, bold = true },
    MoreMsg = { fg = p.string },
    Question = { fg = p.type },
    NonText = { fg = p.fg_subtle },
    Whitespace = { fg = p.border },
    SpecialKey = { fg = p.fg_subtle },
    Pmenu = { fg = p.fg, bg = p.bg_raised },
    PmenuSel = { fg = p.fg_bright, bg = p.selection, bold = true },
    PmenuSbar = { bg = p.bg_raised },
    PmenuThumb = { bg = p.fg_subtle },
    PmenuKind = { fg = p.type, bg = p.bg_raised },
    PmenuExtra = { fg = p.fg_muted, bg = p.bg_raised },
    PmenuMatch = { fg = p.primary_text, bg = p.bg_raised, bold = true },
    Search = { fg = p.fg, bg = p.primary_soft },
    IncSearch = { fg = p.on_primary, bg = p.primary },
    CurSearch = { fg = p.on_primary, bg = p.primary },
    Substitute = { fg = p.bg, bg = p.number },
    MatchParen = { fg = p.accent, bg = p.bg_raised, bold = true },
    StatusLine = { fg = p.fg_muted, bg = p.bg_dim },
    StatusLineNC = { fg = p.fg_subtle, bg = p.bg_dim },
    TabLine = { fg = p.fg_muted, bg = p.bg_dim },
    TabLineFill = { bg = p.bg_deep },
    TabLineSel = { fg = p.fg_bright, bg = p.bg, bold = true },
    WinBar = { fg = p.fg_muted, bg = p.bg },
    WinBarNC = { fg = p.fg_subtle, bg = p.bg },
    WinSeparator = { fg = p.border },
    Title = { fg = p.primary_text, bold = true },
    Visual = { bg = p.selection },
    VisualNOS = { bg = p.selection },
    WildMenu = { link = 'PmenuSel' },
    QuickFixLine = { bg = p.selection, bold = true },
    SpellBad = { sp = p.error, undercurl = true },
    SpellCap = { sp = p.warning, undercurl = true },
    SpellLocal = { sp = p.info, undercurl = true },
    SpellRare = { sp = p.hint, undercurl = true },

    -- Syntax: the fire for keywords, the fireworks or the corals for values,
    -- and the frost or the driftwood for comments.
    Comment = { fg = p.comment, italic = true },
    Constant = { fg = p.number },
    String = { fg = p.string },
    Character = { fg = p.string },
    Number = { fg = p.number },
    Boolean = { fg = p.number },
    Float = { fg = p.number },
    Identifier = { fg = p.fg },
    Function = { fg = fn },
    Statement = { fg = p.keyword },
    Conditional = { fg = p.keyword },
    Repeat = { fg = p.keyword },
    Label = { fg = p.property },
    Keyword = { fg = p.keyword },
    Exception = { fg = p.keyword },
    Operator = { fg = p.operator },
    PreProc = { fg = p.builtin },
    Include = { fg = p.keyword },
    Define = { fg = p.builtin },
    Macro = { fg = p.builtin },
    PreCondit = { fg = p.builtin },
    Type = { fg = p.type },
    StorageClass = { fg = p.keyword },
    Structure = { fg = p.type },
    Typedef = { fg = p.type },
    Special = { fg = p.escape },
    SpecialChar = { fg = p.escape },
    Tag = { fg = p.tag },
    Delimiter = { fg = p.punctuation },
    SpecialComment = { fg = p.comment, bold = true },
    Debug = { fg = p.tag },
    Underlined = { underline = true },
    Ignore = { fg = p.fg_subtle },
    Error = { fg = p.error },
    Todo = { fg = p.on_primary, bg = p.primary, bold = true },

    -- Diffs.
    Added = { fg = p.added },
    Removed = { fg = p.removed },
    Changed = { fg = p.changed },
    DiffAdd = { bg = p.added_soft },
    DiffDelete = { bg = p.removed_soft },
    DiffChange = { bg = p.changed_soft },
    DiffText = { bg = p.selection },
    diffAdded = { link = 'Added' },
    diffRemoved = { link = 'Removed' },
    diffChanged = { link = 'Changed' },
    diffFile = { fg = p.type },
    diffLine = { fg = p.builtin },
    diffIndexLine = { fg = p.builtin },

    -- Treesitter.
    ['@variable'] = { fg = p.fg },
    ['@variable.builtin'] = { fg = p.builtin },
    ['@variable.parameter'] = { fg = p.parameter, italic = true },
    ['@variable.parameter.builtin'] = { fg = p.builtin, italic = true },
    ['@variable.member'] = { fg = p.property },
    ['@constant'] = { fg = p.number },
    ['@constant.builtin'] = { fg = p.number },
    ['@constant.macro'] = { fg = p.builtin },
    ['@module'] = { fg = p.builtin },
    ['@module.builtin'] = { fg = p.builtin },
    ['@label'] = { fg = p.property },
    ['@string'] = { fg = p.string },
    ['@string.documentation'] = { fg = p.string },
    ['@string.regexp'] = { fg = p.escape },
    ['@string.escape'] = { fg = p.escape },
    ['@string.special'] = { fg = p.escape },
    ['@string.special.symbol'] = { fg = p.number },
    ['@string.special.url'] = { fg = p.info, underline = true },
    ['@string.special.path'] = { fg = p.string },
    ['@character'] = { fg = p.string },
    ['@character.special'] = { fg = p.escape },
    ['@boolean'] = { fg = p.number },
    ['@number'] = { fg = p.number },
    ['@number.float'] = { fg = p.number },
    ['@type'] = { fg = p.type },
    ['@type.builtin'] = { fg = p.type },
    ['@type.definition'] = { fg = p.type },
    ['@attribute'] = { fg = p.builtin },
    ['@attribute.builtin'] = { fg = p.builtin },
    ['@property'] = { fg = p.property },
    ['@function'] = { fg = fn },
    ['@function.builtin'] = { fg = p.builtin },
    ['@function.call'] = { fg = fn },
    ['@function.macro'] = { fg = p.builtin },
    ['@function.method'] = { fg = fn },
    ['@function.method.call'] = { fg = fn },
    ['@constructor'] = { fg = p.type },
    ['@operator'] = { fg = p.operator },
    ['@keyword'] = { fg = p.keyword },
    ['@keyword.operator'] = { fg = p.keyword },
    ['@keyword.conditional.ternary'] = { fg = p.operator },
    ['@keyword.directive'] = { fg = p.builtin },
    ['@keyword.directive.define'] = { fg = p.builtin },
    ['@punctuation.delimiter'] = { fg = p.punctuation },
    ['@punctuation.bracket'] = { fg = p.punctuation },
    ['@punctuation.special'] = { fg = p.keyword },
    ['@comment'] = { fg = p.comment, italic = true },
    ['@comment.documentation'] = { fg = p.comment, italic = true },
    ['@comment.error'] = { fg = p.error, bold = true },
    ['@comment.warning'] = { fg = p.warning, bold = true },
    ['@comment.todo'] = { fg = p.on_primary, bg = p.primary, bold = true },
    ['@comment.note'] = { fg = p.info, bold = true },
    ['@markup.strong'] = { bold = true },
    ['@markup.italic'] = { italic = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.underline'] = { underline = true },
    ['@markup.heading'] = { fg = p.keyword, bold = true },
    ['@markup.quote'] = { fg = p.comment, italic = true },
    ['@markup.math'] = { fg = p.number },
    ['@markup.link'] = { fg = p.info },
    ['@markup.link.label'] = { fg = p.info },
    ['@markup.link.url'] = { fg = p.info, underline = true },
    ['@markup.raw'] = { fg = p.string },
    ['@markup.raw.block'] = { fg = p.fg },
    ['@markup.list'] = { fg = p.keyword },
    ['@markup.list.checked'] = { fg = p.success },
    ['@markup.list.unchecked'] = { fg = p.fg_muted },
    ['@diff.plus'] = { link = 'Added' },
    ['@diff.minus'] = { link = 'Removed' },
    ['@diff.delta'] = { link = 'Changed' },
    ['@tag'] = { fg = p.tag },
    ['@tag.builtin'] = { fg = p.tag },
    ['@tag.attribute'] = { fg = p.property },
    ['@tag.delimiter'] = { fg = p.punctuation },

    -- LSP semantic tokens.
    ['@lsp.type.class'] = { link = '@type' },
    ['@lsp.type.decorator'] = { link = '@attribute' },
    ['@lsp.type.enum'] = { link = '@type' },
    ['@lsp.type.enumMember'] = { link = '@constant' },
    ['@lsp.type.function'] = { link = '@function' },
    ['@lsp.type.interface'] = { link = '@type' },
    ['@lsp.type.macro'] = { link = '@function.macro' },
    ['@lsp.type.method'] = { link = '@function.method' },
    ['@lsp.type.namespace'] = { link = '@module' },
    ['@lsp.type.parameter'] = { link = '@variable.parameter' },
    ['@lsp.type.property'] = { link = '@property' },
    ['@lsp.type.struct'] = { link = '@type' },
    ['@lsp.type.type'] = { link = '@type' },
    ['@lsp.type.typeParameter'] = { fg = p.type, italic = true },
    ['@lsp.type.selfKeyword'] = { link = '@variable.builtin' },
    ['@lsp.mod.deprecated'] = { strikethrough = true },
    ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
    ['@lsp.typemod.variable.defaultLibrary'] = { link = '@variable.builtin' },

    -- Diagnostics and the LSP.
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warning },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.hint },
    DiagnosticOk = { fg = p.success },
    DiagnosticUnderlineError = { sp = p.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = p.warning, undercurl = true },
    DiagnosticUnderlineInfo = { sp = p.info, undercurl = true },
    DiagnosticUnderlineHint = { sp = p.hint, undercurl = true },
    DiagnosticVirtualTextError = { fg = p.error, bg = p.removed_soft },
    DiagnosticVirtualTextWarn = { fg = p.warning, bg = p.changed_soft },
    DiagnosticVirtualTextInfo = { fg = p.info, bg = p.secondary_soft },
    DiagnosticVirtualTextHint = { fg = p.hint, bg = p.bg_line },
    DiagnosticUnnecessary = { fg = p.fg_subtle },
    DiagnosticDeprecated = { strikethrough = true },
    LspReferenceText = { bg = p.bg_raised },
    LspReferenceRead = { bg = p.bg_raised },
    LspReferenceWrite = { bg = p.bg_raised, bold = true },
    LspInlayHint = { fg = p.comment, bg = p.bg_line },
    LspCodeLens = { fg = p.comment },
    LspSignatureActiveParameter = { fg = p.primary_text, bold = true },

    -- gitsigns.
    GitSignsAdd = { fg = p.added },
    GitSignsChange = { fg = p.changed },
    GitSignsDelete = { fg = p.removed },

    -- snacks.nvim.
    SnacksDashboardHeader = { fg = p.primary },
    SnacksDashboardKey = { fg = p.primary_text },
    SnacksDashboardDesc = { fg = p.fg },
    SnacksDashboardIcon = { fg = fn },
    SnacksDashboardFooter = { fg = p.comment },
    SnacksDashboardSpecial = { fg = p.builtin },
    SnacksPickerMatch = { fg = p.primary_text, bold = true },
    SnacksPickerBorder = { link = 'FloatBorder' },
    SnacksPickerTitle = { link = 'FloatTitle' },
    SnacksPickerDir = { fg = p.fg_muted },
    SnacksIndent = { fg = p.border },
    SnacksIndentScope = { fg = p.fg_subtle },

    -- blink.cmp.
    BlinkCmpMenu = { link = 'Pmenu' },
    BlinkCmpMenuBorder = { link = 'FloatBorder' },
    BlinkCmpMenuSelection = { link = 'PmenuSel' },
    BlinkCmpLabelMatch = { fg = p.primary_text, bold = true },
    BlinkCmpKind = { fg = p.type },
    BlinkCmpDoc = { link = 'NormalFloat' },
    BlinkCmpDocBorder = { link = 'FloatBorder' },
    BlinkCmpGhostText = { fg = p.fg_subtle },

    -- which-key.nvim.
    WhichKey = { fg = p.primary_text },
    WhichKeyGroup = { fg = p.type },
    WhichKeyDesc = { fg = p.fg },
    WhichKeySeparator = { fg = p.fg_subtle },
    WhichKeyValue = { fg = p.comment },
    WhichKeyNormal = { link = 'NormalFloat' },
    WhichKeyBorder = { link = 'FloatBorder' },

    -- noice.nvim and flash.nvim.
    NoiceCmdlinePopupBorder = { fg = p.accent },
    NoiceCmdlineIcon = { fg = p.accent },
    FlashLabel = { fg = p.on_primary, bg = p.primary, bold = true },
    FlashMatch = { fg = p.fg, bg = p.selection },
    FlashCurrent = { fg = p.bg, bg = p.type },

    -- mini.icons.
    MiniIconsAzure = { fg = p.type },
    MiniIconsBlue = { fg = p.info },
    MiniIconsCyan = { fg = p.type },
    MiniIconsGreen = { fg = p.string },
    MiniIconsGrey = { fg = p.fg_muted },
    MiniIconsOrange = { fg = p.primary_text },
    MiniIconsPurple = { fg = p.builtin },
    MiniIconsRed = { fg = p.tag },
    MiniIconsYellow = { fg = fn },

    -- Telescope, neo-tree, indent-blankline, lazy.nvim and mason.
    TelescopeBorder = { link = 'FloatBorder' },
    TelescopeSelection = { link = 'PmenuSel' },
    TelescopeMatching = { fg = p.primary_text, bold = true },
    TelescopePromptPrefix = { fg = p.accent },
    NeoTreeNormal = { fg = p.fg, bg = p.bg_dim },
    NeoTreeNormalNC = { fg = p.fg, bg = p.bg_dim },
    NeoTreeDirectoryIcon = { fg = p.type },
    IblIndent = { fg = p.border },
    IblScope = { fg = p.fg_subtle },
    LazyH1 = { fg = p.on_primary, bg = p.primary, bold = true },
    LazyButtonActive = { fg = p.on_primary, bg = p.primary, bold = true },
    MasonHeader = { fg = p.on_primary, bg = p.primary, bold = true },
    MasonHighlight = { fg = p.primary_text },
  }
end

--- Loads a theme, such as 'lrssn-hearth'.
---@param name string
function M.load(name)
  local p = M.palette(name)
  -- Setting 'background' reloads the current colour scheme. When the new
  -- value does not match it, load the theme of the other mode instead, so
  -- that `:set background=light` turns Hearth into Shore, and back.
  if vim.g.colors_name == name and vim.o.background ~= p.mode then
    name = vim.o.background == 'light' and 'lrssn-shore' or 'lrssn-hearth'
    p = M.palette(name)
  end
  -- `:highlight clear` also unsets `g:colors_name`, so setting 'background'
  -- next does not reload the previous colour scheme.
  vim.cmd('highlight clear')
  if vim.fn.exists('syntax_on') == 1 then
    vim.cmd('syntax reset')
  end
  vim.o.termguicolors = true
  vim.o.background = p.mode
  vim.g.colors_name = name
  for group, spec in pairs(M.highlights(p)) do
    vim.api.nvim_set_hl(0, group, spec)
  end
  for index, colour in ipairs(ANSI) do
    vim.g['terminal_color_' .. (index - 1)] = p.ansi[colour]
  end
end

return M
