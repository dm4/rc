local windowManagement = hs.hotkey.modal.new({"alt"}, "1")
local windowManagementAlert

local keyLabels = {
  Left = "←",
  Right = "→",
  Space = "Sp",
  Tab = "Tab",
  Escape = "Esc",
}

local windowManagementActions = {
  {
    key = "Left",
    description = "Left  Half",
    run = function(win)
      win:moveToUnit({0, 0, 0.5, 1})
    end,
  },
  {
    key = "Right",
    description = "Right Half",
    run = function(win)
      win:moveToUnit({0.5, 0, 0.5, 1})
    end,
  },
  {
    key = "[",
    description = "Left  4/5",
    run = function(win)
      win:moveToUnit({0, 0, 0.8, 1})
    end,
  },
  {
    key = "]",
    description = "Right 1/5",
    run = function(win)
      -- frame() must see the width that the app actually accepts.
      win:moveToUnit({0.8, 0, 0.2, 1}, 0)

      local screenFrame = win:screen():frame()
      local windowFrame = win:frame()
      win:setTopLeft({
        x = screenFrame.x + screenFrame.w - windowFrame.w,
        y = windowFrame.y,
      })
    end,
  },
  {
    key = "\\",
    description = "Right 2/3",
    run = function(win)
      win:moveToUnit({0.33, 0, 0.67, 1})
    end,
  },
  {
    key = "Space",
    description = "Fullscreen",
    run = function(win)
      win:maximize()
    end,
  },
  {
    key = "Tab",
    description = "Center",
    run = function(win)
      win:centerOnScreen()
    end,
  },
  {
    key = "Escape",
    description = "Cancel",
  },
}

local function windowManagementMessage()
  local lines = {"Window Mode", ""}
  local keyWidth = 0

  for _, action in ipairs(windowManagementActions) do
    local key = keyLabels[action.key] or action.key
    keyWidth = math.max(keyWidth, utf8.len(key))
  end

  for _, action in ipairs(windowManagementActions) do
    local key = keyLabels[action.key] or action.key
    local padding = string.rep(" ", keyWidth - utf8.len(key))
    table.insert(lines, padding .. key .. "  " .. action.description)
  end

  return table.concat(lines, "\n")
end

function windowManagement:entered()
  windowManagementAlert = hs.alert.show(windowManagementMessage(), {
    textFont = "SauceCodeProNFM",
    textSize = 20,
    radius = 10,
    padding = 12,
  }, "indefinite")
end

function windowManagement:exited()
  if windowManagementAlert then
    hs.alert.closeSpecific(windowManagementAlert)
    windowManagementAlert = nil
  end
end

for _, action in ipairs(windowManagementActions) do
  local currentAction = action

  windowManagement:bind({}, currentAction.key, function()
    if currentAction.run then
      local win = hs.window.focusedWindow()
      if win then
        currentAction.run(win)
      end
    end

    windowManagement:exit()
  end)
end

return windowManagement
