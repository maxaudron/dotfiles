local pointer = require("config/pointer")

hl.config({
	input = {
		kb_layout = "us",
		kb_options = "compose:rctrl",

		follow_mouse = 1,
		accel_profile = "flat",

		sensitivity = 0.5,
	},
})

hl.device({
	name = "kensington-expert-wireless-tb-mouse",
	accel_profile = pointer.accel(400, 140, 1.0, 60, 1.6),
})

hl.device({
	name = "keychron--keychron-link-km",
	accel_profile = pointer.accel(1600, 140, 1.0, 60, 1.4),
})
