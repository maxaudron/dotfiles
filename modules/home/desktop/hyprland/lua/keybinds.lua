local mod = "SUPER"
local modS = "SUPER+SHIFT"

local terminal = "ghostty"
local noctalia = "noctalia-shell ipc call"

hl.bind(mod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true }) -- ALT + LMB: Move a window
hl.bind(mod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true }) -- ALT + RMB: Resize a window

hl.bind(mod .. "+ return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. "+ space", hl.dsp.exec_cmd(noctalia .. " launcher toggle"))
hl.bind(mod .. "+ I", hl.dsp.exec_cmd(noctalia .. " controlCenter toggle"))
hl.bind(mod .. "+ comma", hl.dsp.exec_cmd(noctalia .. " settings toggle"))
hl.bind(mod .. "+ v", hl.dsp.exec_cmd(noctalia .. " launcher clipboard"))
hl.bind(mod .. "+ u", hl.dsp.exec_cmd(noctalia .. " launcher calculator"))
hl.bind(mod .. "+ l", hl.dsp.exec_cmd(noctalia .. " lockScreen toggle"))

hl.bind(mod .. "+ s", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. "+ f", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("code:121", hl.dsp.pass({ window = "class:^(TeamSpeak.*?)$" }))
hl.bind("code:122", hl.dsp.pass({ window = "class:^(TeamSpeak.*?)$" }))
hl.bind("code:123", hl.dsp.pass({ window = "class:^(TeamSpeak.*?)$" }))
