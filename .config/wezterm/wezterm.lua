local term = require("wezterm")
local keybinds = require("keybinds")

--------------------------------------
-- Local Functions
--------------------------------------
function recompute_padding(window)
	local window_dims = window:get_dimensions()
	local overrides = window:get_config_overrides() or {}

	if not window_dims.is_full_screen then
		if not overrides.window_padding then
			-- not changing anything
			return
		end
		overrides.window_padding = nil
	else
		-- Use only the middle 33%
		local third = math.floor(window_dims.pixel_width / 3)
		local new_padding = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
		if overrides.window_padding and new_padding.left == overrides.window_padding.left then
			-- padding is same, avoid triggering further changes
			return
		end
		overrides.window_padding = new_padding
	end
	window:set_config_overrides(overrides)
end

term.on("window-resized", function(window, pane)
	recompute_padding(window)
end)
term.on("window-config-reloaded", function(window)
	recompute_padding(window)
end)

term.on("format-tab-title", function(tab)
	local tab_index = string.format("  %s  ", tab.tab_index + 1)
	return term.format({
		-- { Text = "▏" },
		{ Text = tab_index },
	})
end)
term.on("update-right-status", function(window, pane)
	local cells = {}
	local key_mode = window:active_key_table()
	local mode = {
		["search_mode"] = "󰜏",
		["copy_mode"] = "",
	}
	if not key_mode then
		table.insert(cells, "")
	else
		table.insert(cells, mode[key_mode])
	end

	--
	local workspace = window:active_workspace()
	if workspace == "default" then
		workspace = ""
	end
	table.insert(cells, workspace)

	local cwd_uri = pane:get_current_working_dir()
	if cwd_uri then
		cwd_uri = cwd_uri:sub(8)
		local slash = cwd_uri:find("/")
		local cwd = ""
		local hostname = ""
		if slash then
			hostname = cwd_uri:sub(1, slash - 1)
			-- Remove the domain name portion of the hostname
			local dot = hostname:find("[.]")
			if dot then
				hostname = hostname:sub(1, dot - 1)
			end
			-- and extract the cwd from the uri
			cwd = cwd_uri:sub(slash)
			-- table.insert(cells, cwd)
			if hostname == "" then
				table.insert(cells, "")
			elseif string.find(hostname, "arch") then
				table.insert(cells, "")
			else
				table.insert(cells, "")
			end
		end
	end
	local current_time = tonumber(term.strftime("%H"))
	-- stylua: ignore
	local time = {
		[00] = "",
		[01] = "",
		[02] = "",
		[03] = "",
		[04] = "",
		[05] = "",
		[06] = "",
		[07] = "",
		[08] = "",
		[09] = "",
		[10] = "󰗲",
		[11] = "",
		[12] = "",
		[13] = "",
		[14] = "",
		[15] = "",
		[16] = "",
		[17] = "",
		[18] = "",
		[19] = "󰗲",
		[20] = "",
		[21] = "",
		[22] = "",
		[23] = "",
	}
	local date = term.strftime("%H:%M:%S %a %b %d ")
	local date_time = time[current_time] .. " " .. date
	table.insert(cells, date_time)
	local text_fg = terminal.colors.transparent
	-- local SEPERATOR = " █"
	local SEPERATOR = "  "
	local pallete = {
		"#f7768e",
		"#9ece6a",
		"#7dcfff",
		"#bb9af7",
		"#e0af68",
		"#7aa2f7",
	}
	local cols = pane:get_dimensions().cols
	local padding = term.pad_right("", (cols / 2) - string.len(date_time) - 2)
	local elements = {}
	local num_cells = 0

	-- Translate into elements
	function push(text, is_last)
		local cell_no = num_cells + 1
		if is_last then
			-- table.insert(elements, text_fg)
			table.insert(elements, { Text = padding })
		end
		table.insert(elements, { Foreground = { Color = pallete[cell_no] } })
		table.insert(elements, { Background = { Color = terminal.colors.transparent } })
		table.insert(elements, { Text = "" .. text .. "" })
		if not is_last then
			table.insert(elements, { Foreground = { Color = terminal.colors.transparent } })
			table.insert(elements, { Background = { Color = terminal.colors.transparent } })
			table.insert(elements, { Text = SEPERATOR })
		end
		num_cells = num_cells + 1
	end

	while #cells > 0 do
		local cell = table.remove(cells, 1)
		push(cell, #cells == 0)
	end
	window:set_right_status(term.format(elements))
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
  font = term.font("FiraCode Nerd Font"),
  font_size = 12,
  window_decorations = "RESIZE",
  text_background_opacity = 1.0,
  window_background_opacity = 1,
  enable_scroll_bar = false,
  default_cursor_style = "SteadyBar",
  cursor_blink_rate = 333,
  inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
  window_padding = { left = "1px", right = "1px", top = "0.1cell", bottom = "0.1cell" },



  ----- Keys
	leader = { key = "Space", mods = "CTRL" },
	keys = keybinds.create_keybinds(),
	key_tables = keybinds.key_tables,

  ----- Misc
  adjust_window_size_when_changing_font_size = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  audible_bell = "Disabled",
  exit_behavior = "CloseOnCleanExit",
  window_close_confirmation = "AlwaysPrompt",
  scrollback_lines = 50000,
  hide_tab_bar_if_only_one_tab = true,
  show_new_tab_button_in_tab_bar = false,
  allow_win32_input_mode = true,
  disable_default_key_bindings = true
}

return config
