local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Update
config.check_for_updates = true

-- Fonts, colors, styles and graphics
config.font = wezterm.font('SauceCodePro Nerd Font', {weight = 'Light'})
config.font_size = 20
config.color_scheme = 'Seti UI (base16)'
config.underline_position = '200%'
config.enable_kitty_graphics = true

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
-- Get the title of the tab
--   * If the tab title is explicitly set, take that
--   * Otherwise, use the title from the active pane in that tab
function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
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
    local title = tab_title(tab)
    local full_title = '[' .. tab.tab_index + 1 .. '] ' .. title
    local pad_length = (wezterm.GLOBAL.cols // #tabs - #full_title) // 2
    if pad_length * 2 + #full_title > max_width then
      pad_length = (max_width - #full_title) // 2
    end
    return string.rep(' ', pad_length) .. full_title .. string.rep(' ', pad_length)
  end
)

-- User variables
wezterm.on(
  'user-var-changed',
  function(window, pane, name, value)
    if name == 'open-url' then
      wezterm.run_child_process { 'open', value }
    end
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
  -- Quick ssh
  {
    key = 'p',
    mods = 'CTRL|CMD',
    action = wezterm.action_callback(function(window, pane)
      local tab, _, _ = window:mux_window():spawn_tab({
        args = { 'ssh', 'pn51' },
      })
      tab:set_title('pn51')
    end),
  },
  {
    key = 'l',
    mods = 'CTRL|CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { 'ssh', 'dm4' },
    },
  },
  {
    key = 'n',
    mods = 'CTRL|CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { 'ssh', 'n2' },
    },
  },
  -- Close tab without confirmation
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
  -- Move tabs
  { key = '{', mods = 'CMD|ALT', action = wezterm.action.MoveTabRelative(-1) },
  { key = '}', mods = 'CMD|ALT', action = wezterm.action.MoveTabRelative(1) },
}

return config

-- vim: ft=lua sw=2 ts=2 et
