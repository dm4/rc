-- Auto Reload
function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end
local configWather = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()


-- URL Event
hs.urlevent.bind("test", function(eventName, params)
  hs.alert.show("測試")
end)


-- Application Shortcuts
require("application-shortcuts")


-- Key Bindings
require("key-bindings")


-- Window Management
require("window-management")


-- Reload message
hs.alert.show("Hammerspoon Reloaded", {
  textSize = 20,
  radius = 10,
  atScreenEdge = 2,
})
