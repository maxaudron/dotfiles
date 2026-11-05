hl.monitor({
	output = "DP-1",
	mode = "3840x2160@240",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	cm = "srgb",
  -- sdrbrightness = 1.25,
  -- sdrsaturation = 1,
  -- sdr_max_luminance = 139,
  -- sdr_min_luminance = 0,
	-- vrr = 1,
	icc = "/home/audron/.dotfiles/misc/icc/liduur_dp1_srgb2.icc",
})

hl.monitor({
	output = "DP-2",
	mode = "2560x1080@60",
	position = "3840x0",
	scale = 1,
	transform = 3,
	cm = "srgb",
	-- icc = "/home/audron/.dotfiles/misc/icc/liduur_dp2.icc",
})
