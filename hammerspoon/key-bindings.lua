-- Synergy Start / Stop
local toggleSynergy = require("toggle-synergy")
hs.hotkey.bind({"alt", "shift", "cmd"}, "s", toggleSynergy)


-- Hammerspoon Reload
hs.hotkey.bind({"cmd", "alt"}, "r", function()
  hs.reload()
end)


-- Set Monitor Input (DP-1)
hs.hotkey.bind({"ctrl", "cmd", "alt", "shift"}, "1", function()
  hs.execute("/opt/homebrew/bin/m1ddc display 1 set input 15")
end)


-- Set Monitor Input (HDMI-1)
hs.hotkey.bind({"ctrl", "cmd", "alt", "shift"}, "2", function()
  hs.execute("/opt/homebrew/bin/m1ddc display 1 set input 17")
end)


-- Set Monitor Input (HDMI-2)
hs.hotkey.bind({"ctrl", "cmd", "alt", "shift"}, "3", function()
  hs.execute("/opt/homebrew/bin/m1ddc display 1 set input 18")
end)
