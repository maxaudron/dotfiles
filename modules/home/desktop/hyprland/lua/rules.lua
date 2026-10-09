hl.window_rule({
	name = "float-imv",
	match = { class = "imv" },
	float = true,
})

hl.window_rule({
	name = "float-mpv",
	match = { class = "mpv" },
	float = true,
})

hl.window_rule({
	name = "buddy3d",

	match = {
		class = "^mpv$",
		title = "^buddy3d$",
	},

	float = true,
	monitor = "DP-2",
	move = { 20, "(monitor_h / 3) * 2 + 20" },
	size = { 427, 240 },
	animation = "popin",
})

-- DisplayCal
hl.window_rule({
	name = "Calibration",

	match = {
		class = "^displaycal$",
		title = "^Calibration$",
	},

	float = true,
	monitor = "DP-1",
	move = { 20, 20 },
	size = { 427, 240 },
})

hl.window_rule({
	name = "Calibration",

	match = {
		class = "^displaycal$",
		title = "^Interactive display adjustment$",
	},

	float = true,
	monitor = "DP-1",
	move = { 20, 20 },
	size = { 427, 240 },
})

hl.window_rule({
	name = "Calibration",

  match = {
		class = "^displaycal$",
		title = "^DisplayCAL$",
	},

	float = true,
	monitor = "DP-1",
	move = { 20, 20 },
	size = { 427, 240 },
})
