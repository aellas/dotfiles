local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font =
wezterm.font('IosevkaTerm Nerd Font', { weight = 'Regular', italic = false })
config.font_size = 13
config.color_scheme = 'tokyonight_night'

config.enable_tab_bar = false
config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 500
config.term = "xterm-256color"
config.bold_brightens_ansi_colors = false
config.max_fps = 120
config.animation_fps = 30
config.window_close_confirmation = 'NeverPrompt'

return config
