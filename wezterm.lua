local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Update
config.check_for_updates = true

-- Fonts, colors, and styles
config.font = wezterm.font('SauceCodePro Nerd Font', {weight = 'Light'})
config.font_size = 20
config.color_scheme = 'Seti UI (base16)'
config.underline_position = '200%'

-- Tab bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 999

-- Tab bar width (fill the window)
--   * Get the cols of the tab, save it to wezterm.GLOBAL.cols
--   * Calculate the max cols for each tab
--   * If the max cols is exceeded max_width, use max_width to calculate the max cols for each tab
function get_max_cols(window)
  local tab = window:active_tab()
  local cols = tab:get_size().cols
  return cols
end
wezterm.on(
  'window-config-reloaded',
  function(window)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)
wezterm.on(
  'window-resized',
  function(window, pane)
    wezterm.GLOBAL.cols = get_max_cols(window)
  end
)
wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = tab.active_pane.title
    local full_title = '[' .. tab.tab_index + 1 .. '] ' .. title
    local pad_length = (wezterm.GLOBAL.cols // #tabs - #full_title) // 2
    if pad_length * 2 + #full_title > max_width then
      pad_length = (max_width - #full_title) // 2
    end
    return string.rep(' ', pad_length) .. full_title .. string.rep(' ', pad_length)
  end
)

-- Window
config.window_decorations = 'RESIZE'
config.window_padding = {
  top = 0,
  bottom = 0,
}

-- Fullscreen on startup
local mux = wezterm.mux
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

-- Keys
config.keys = {
  {
    key = 'p',
    mods = 'CTRL|CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { 'ssh', 'pn51' },
    },
  },
  {
    key = 'n',
    mods = 'CTRL|CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { 'ssh', 'n2' },
    },
  },
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

return config

-- vim: ft=lua sw=2 ts=2 et
