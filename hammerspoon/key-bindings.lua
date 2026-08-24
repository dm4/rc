-- Synergy Start / Stop
local toggleSynergy = require("toggle-synergy")
hs.hotkey.bind({"alt", "shift", "cmd"}, "s", toggleSynergy)


-- Hammerspoon Reload
hs.hotkey.bind({"cmd", "alt"}, "r", function()
  hs.reload()
end)
