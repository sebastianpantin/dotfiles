local M = {}
local wezterm = require("wezterm")
local act = wezterm.action

---------------------------------------------------------------
--- keybinds
---------------------------------------------------------------

M.tmux_keybinds = {
	--- Tabs
	{ key = "h", mods = "ALT", action = act({ ActivateTabRelative = -1 }) },
	{ key = "l", mods = "ALT", action = act({ ActivateTabRelative = 1 }) },
	{ key = "t", mods = "LEADER", action = act.ActivateKeyTable {
			name = "tab",
			one_shot = true,
		}
	},

	--- Panes
	{ key = "n", mods = "ALT", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "n", mods = "ALT|SHIFT", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "h", mods = "ALT|SHIFT", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "l", mods = "ALT|SHIFT", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "k", mods = "ALT|SHIFT", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "j", mods = "ALT|SHIFT", action = act({ ActivatePaneDirection = "Down" }) },

}

M.key_tables = {
	tab = {
		{ key = "n", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "x", action = act.CloseCurrentTab({ confirm = true }) },
	}
}

function M.create_keybinds()
	return M.tmux_keybinds
end

return M
