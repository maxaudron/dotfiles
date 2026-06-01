hl.config({
	plugins = {
		hy3 = {
			-- group_inset = 50,

			-- tabs = {
				-- height = 42,
				-- padding = 0,
				-- radius = 15,
				-- border_width = 2,

				-- # active tab bar segment colors
				-- "col.active" = "$surface0";
				-- "col.active.border" = "$mauve";
				-- "col.active.text" = "$mauve";

				-- # active tab bar segment colors for bars on an unfocused monitor
				-- "col.active_alt_monitor" = "$surface0";
				-- "col.active_alt_monitor.border" = "$mauve";
				-- "col.active_alt_monitor.text" = "$mauve";

				-- # focused tab bar segment colors (focused node in unfocused container)
				-- "col.focused" = "$surface0";
				-- "col.focused.border" = "$surface0";
				-- "col.focused.text" = "$surface0";

				-- # inactive tab bar segment colors
				-- "col.inactive" = "$surface0";
				-- "col.inactive.border" = "$surface0";
				-- "col.inactive.text" = "$surface0";

				-- # urgent tab bar segment colors
				-- "col.urgent" = "$surface0";
				-- "col.urgent.border" = "$red";
				-- "col.urgent.text" = "$red";

				-- # locked tab bar segment colors
				-- "col.locked" = "$surface0";
				-- "col.locked.border" = "$peach";
				-- "col.locked.text" = "$peach";
			-- },

			-- autotile = {
			-- 	enable = true,
			-- 	trigger_width = 800,
			-- 	trigger_height = 500,
			-- },
		},
	},
})

local mod = "SUPER"
local modS = "SUPER+SHIFT"
local hy3 = hl.plugin.hy3

hl.bind(mod .. "+ c", hy3.kill_active())

hl.bind("ALT + tab", hy3.focus_tab({ direction = "r", wrap = true }))

hl.bind(mod .. "+ e", hy3.change_focus("raise"))
hl.bind(modS .. "+ t", hy3.change_focus("lower"))

hl.bind(mod .. "+ t", hy3.change_group("toggletab"))
hl.bind(mod .. "+ r", hy3.change_group("opposite"))

hl.bind(mod .. "+ h", hy3.move_focus("l"))
hl.bind(mod .. "+ j", hy3.move_focus("d"))
hl.bind(mod .. "+ k", hy3.move_focus("u"))
hl.bind(mod .. "+ l", hy3.move_focus("r"))

hl.bind(modS .. "+ h", hy3.move_window("l", {}))
hl.bind(modS .. "+ j", hy3.move_window("d", {}))
hl.bind(modS .. "+ k", hy3.move_window("u", {}))
hl.bind(modS .. "+ l", hy3.move_window("r", {}))

hl.bind(modS .. "+ 1", hy3.move_to_workspace("1", {}))
hl.bind(modS .. "+ 2", hy3.move_to_workspace("2", {}))
hl.bind(modS .. "+ 3", hy3.move_to_workspace("3", {}))
hl.bind(modS .. "+ 4", hy3.move_to_workspace("4", {}))
hl.bind(modS .. "+ 5", hy3.move_to_workspace("5", {}))

hl.bind(mod .. "+ n", hy3.make_group("v", { toggle = true }))
hl.bind(mod .. "+ m", hy3.make_group("h", { toggle = true }))
