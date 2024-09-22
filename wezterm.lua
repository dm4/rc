local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.check_for_updates = true
config.font = wezterm.font('SauceCodePro Nerd Font', {weight = 'Light'})
config.font_size = 20
config.color_scheme = 'Seti UI (base16)'
config.underline_position = '200%'

-- Tab bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- Window
config.window_decorations = 'RESIZE'
config.window_padding = {
  top = 0,
  bottom = 0,
}

local mux = wezterm.mux
wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window{}
  window:gui_window():maximize()
end)

return config

-- vim: ft=lua sw=2 ts=2 et
