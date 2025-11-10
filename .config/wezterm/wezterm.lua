local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font =
wezterm.font('IosevkaTerm Nerd Font', { weight = 'Regular', italic = false })
config.font_size = 13
config.color_scheme = 'tokyonight_night'
config.front_end = 'OpenGL'
config.freetype_load_target = 'Light'
config.freetype_render_target = 'HorizontalLcd'
config.cell_width = 0.9
config.enable_tab_bar = false 
config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 500
config.term = "xterm-256color"
config.bold_brightens_ansi_colors = false
config.max_fps = 120
config.animation_fps = 30
config.window_close_confirmation = 'NeverPrompt'
config.freetype_load_flags = 'NO_HINTING'
return config
