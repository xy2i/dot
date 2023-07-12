local wezterm = require 'wezterm'
local act = wezterm.action

local home = os.getenv("HOME")

return {
  font = wezterm.font 'JetBrains Mono',
  font_size = 11,
  line_height = 0.75,

  color_scheme = "Catppuccin Mocha",
  
  -- window_decorations = "RESIZE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },

  window_background_opacity = .7,

  hide_tab_bar_if_only_one_tab = true, 
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
}
