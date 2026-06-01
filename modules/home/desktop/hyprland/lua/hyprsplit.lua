local hs = require("hyprsplit")

hs.config({
	num_workspaces = 5,
	persistent_workspaces = true,
})

for i = 1, 5 do
	hl.bind("SUPER + " .. i, hs.dsp.focus({ workspace = i }))
	hl.bind("SUPER + SHIFT + " .. i, hs.dsp.window.move({ workspace = i, follow = false }))
end
