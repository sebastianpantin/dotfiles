local term = require("wezterm")
local keybinds = require("keybinds")

--------------------------------------
-- Local Functions
--------------------------------------

term.on("format-tab-title", function(tab)
	local tab_index = string.format("  %s  ", tab.tab_index + 1)
	return term.format({
		-- { Text = "▏" },
		{ Text = tab_index },
	})
end)

---------------------------------------------------------------
--- Config
---------------------------------------------------------------
local config = {
	status_update_interval = 1000,
	color_scheme = "Catppuccin Macchiato",

	animation_fps = 144,
	max_fps = 144,

	initial_cols = 117,
	initial_rows = 32,
	font = term.font("IosevkaTerm Nerd Font"),
	font_size = 14,
	window_decorations = "RESIZE",
	text_background_opacity = 1.0,
	window_background_opacity = 1,
	enable_scroll_bar = false,
	default_cursor_style = "SteadyBar",
	cursor_blink_rate = 333,
	inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
	window_padding = { left = "1px", right = "1px", top = "0.1cell", bottom = "0.1cell" },
	check_for_updates = false,
	use_ime = true,
	ime_preedit_rendering = "Builtin",
	use_dead_keys = false,
	warn_about_missing_glyphs = false,

	----- Keys
	leader = { key = "Space", mods = "CTRL" },
	keys = keybinds.create_keybinds(),
	key_tables = keybinds.key_tables,

	----- Misc
	adjust_window_size_when_changing_font_size = true,
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	audible_bell = "Disabled",
	exit_behavior = "Close",
	window_close_confirmation = "AlwaysPrompt",
	scrollback_lines = 50000,
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,
	allow_win32_input_mode = true,
	disable_default_key_bindings = false,
}

return config
