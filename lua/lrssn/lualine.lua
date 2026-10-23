-- The lualine themes of the Lrssn colour themes.
--
-- lualine finds them by the name of the colour scheme, through
-- lua/lualine/themes/lrssn-hearth.lua and lrssn-shore.lua.
local M = {}

--- Returns the lualine theme of a theme, such as 'lrssn-hearth'.
---@param name string
---@return table
function M.theme(name)
  local p = require('lrssn').palette(name)

  -- Each mode fills section `a` with its own colour. The brand orange takes
  -- `on-primary` text, and the other colours take the background of the
  -- theme, which reads well on them in both themes.
  local function mode(colour, text)
    return {
      a = { fg = text or p.bg, bg = colour, gui = 'bold' },
      b = { fg = p.fg, bg = p.bg_raised },
      c = { fg = p.fg_muted, bg = p.bg_dim },
    }
  end

  return {
    normal = mode(p.primary, p.on_primary),
    insert = mode(p.string),
    visual = mode(p.number),
    replace = mode(p.tag),
    command = mode(p['function']),
    terminal = mode(p.type),
    inactive = {
      a = { fg = p.fg_subtle, bg = p.bg_dim },
      b = { fg = p.fg_subtle, bg = p.bg_dim },
      c = { fg = p.fg_subtle, bg = p.bg_dim },
    },
  }
end

return M
