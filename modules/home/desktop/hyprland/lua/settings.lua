hl.config({
	general = {
		layout = "hy3",

		gaps_in = 10,
		gaps_out = 20,
		border_size = 2,
		resize_on_border = true,
	},

	decoration = {
		rounding = 15,
		rounding_power = 2.6,

		shadow = {
			enabled = true,
			range = 14,
			render_power = 3,
		},
	},

	cursor = {
		hide_on_key_press = true,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		key_press_enables_dpms = true,
		session_lock_xray = true,
	},
})

require("config/input")
require("config/rules")
require("config/keybinds")
require("config/hy3")
require("config/hyprsplit")

local function getHostname()
	local f = io.popen("/usr/bin/env hostname")
	if f ~= nil then
		local hostname = f:read("*a") or ""
		f:close()
		hostname = string.gsub(hostname, "\n$", "")
		return hostname
	else
		return nil
	end
end

local hostname = getHostname()
if hostname ~= nil then
	require("config/machines/" .. hostname)
end
