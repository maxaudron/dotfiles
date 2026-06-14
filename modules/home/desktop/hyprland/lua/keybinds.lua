local mod = "SUPER"
local modS = "SUPER+SHIFT"

local terminal = "ghostty"
local noctalia = "noctalia msg panel-toggle"

hl.bind(mod .. "+ mouse:272", hl.dsp.window.drag(), { mouse = true }) -- ALT + LMB: Move a window
hl.bind(mod .. "+ mouse:273", hl.dsp.window.resize(), { mouse = true }) -- ALT + RMB: Resize a window

hl.bind(mod .. "+ return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. "+ space", hl.dsp.exec_cmd(noctalia .. " launcher"))
hl.bind(mod .. "+ I", hl.dsp.exec_cmd(noctalia .. " control-center"))
hl.bind(mod .. "+ comma", hl.dsp.exec_cmd(noctalia .. " settings"))
hl.bind(mod .. "+ v", hl.dsp.exec_cmd(noctalia .. " clipboard"))
-- hl.bind(modS .. "+ l", hl.dsp.exec_cmd(noctalia .. " session lock"))

hl.bind(mod .. "+ s", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. "+ f", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind("code:121", hl.dsp.pass({ window = "class:^(TeamSpeak.*?)$" }))
hl.bind("code:122", hl.dsp.pass({ window = "class:^(TeamSpeak.*?)$" }))
hl.bind("code:123", hl.dsp.pass({ window = "class:^(TeamSpeak.*?)$" }))
