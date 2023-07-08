local wezterm = require 'wezterm'
local act = wezterm.action

local home = os.getenv("HOME")

return {
  font = wezterm.font 'JetBrains Mono',
  font_size = 11,
  line_height = 0.75,

  color_scheme_dirs = { home .. '/.cache/wal' },
  color_scheme = "Pywal",
  
  -- window_decorations = "RESIZE",
  window_padding = {
    left = 10,
    right = 0,
    top = 0,
    bottom = 0,
  },

  window_background_opacity = .95,

  hide_tab_bar_if_only_one_tab = true, 
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
}
