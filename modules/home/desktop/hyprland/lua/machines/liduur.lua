hl.monitor({
	output = "DP-1",
	mode = "3840x2160@240",
	position = "0x0",
	scale = 1,
	bitdepth = 10,
	cm = "dp3",
	vrr = 1,
	-- icc = "/home/audron/.dotfiles/misc/icc/liduur_dp1.icc",
})

hl.monitor({
	output = "DP-2",
	mode = "2560x1080@60",
	position = "3840x0",
	scale = 1,
	transform = 3,
	-- icc = "/home/audron/.dotfiles/misc/icc/liduur_dp2.icc",
})
