local wezterm = require 'wezterm'
local act = wezterm.action

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = '<'

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = '>'


wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#2b2042'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    -- ensure that the titles fit in the available space,
    -- and that we have room for the edges.
    local title = wezterm.truncate_right(tab.active_pane.title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end
)

return {
  font = wezterm.font 'Sudo',
  font_size = 10,
  color_scheme = 'ayu',
  window_background_opacity = 0.9,

  -- window_decorations = "RESIZE",
  window_padding = {
    left = 2,
    right = 2,
    top = 0,
    bottom = 0,
  },

  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,

}
