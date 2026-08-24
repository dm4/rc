local synergyProcessCommand = "/usr/bin/pgrep -x synergy-tray"
local synergyToggleInProgress = false

local function findMenuItem(element, title, depth)
  if depth < 0 then
    return nil
  end

  local role = element:attributeValue("AXRole")
  local elementTitle = element:attributeValue("AXTitle")
  if role == "AXMenuItem" and elementTitle == title then
    return element
  end

  local children = element:attributeValue("AXChildren") or {}
  for _, child in ipairs(children) do
    local menuItem = findMenuItem(child, title, depth - 1)
    if menuItem then
      return menuItem
    end
  end

  return nil
end


local function getSynergyApplicationElement()
  -- synergy-tray is started by synergy-service as a background helper, so find
  -- its PID directly and use Accessibility to access it.
  local output, succeeded = hs.execute(synergyProcessCommand)
  local pid = succeeded and tonumber(output:match("%d+"))
  if not pid then
    return nil, false
  end

  return hs.axuielement.applicationElementForPID(pid), true
end


local function pressSynergyAction(menuBarItem, attemptsRemaining)
  local action = findMenuItem(menuBarItem, "Start", 4)
    or findMenuItem(menuBarItem, "Stop", 4)

  if action then
    local actionTitle = action:attributeValue("AXTitle")
    local pressed = action:performAction("AXPress")
    synergyToggleInProgress = false

    if pressed then
      local status = actionTitle == "Start" and "Started" or "Stopped"
      hs.alert.show("Synerge " .. status)
    else
      hs.alert.show("無法執行 Synergy 的 Start 或 Stop")
    end
    return
  end

  if attemptsRemaining == 0 then
    synergyToggleInProgress = false
    hs.alert.show("找不到 Synergy 的 Start 或 Stop")
    return
  end

  hs.timer.doAfter(0.05, function()
    pressSynergyAction(menuBarItem, attemptsRemaining - 1)
  end)
end


local function toggleSynergy()
  if synergyToggleInProgress then
    return
  end

  local applicationElement, processIsRunning = getSynergyApplicationElement()
  if not processIsRunning then
    hs.alert.show("synergy-tray 尚未啟動")
    return
  end

  if not applicationElement then
    hs.alert.show("無法讀取 Synergy accessibility element")
    return
  end

  local menuBar = applicationElement:attributeValue("AXExtrasMenuBar")
  if not menuBar then
    hs.alert.show("找不到 Synergy menu bar")
    return
  end

  local menuBarItems = menuBar:attributeValue("AXChildren") or {}
  local menuBarItem = menuBarItems[1]
  if not menuBarItem then
    hs.alert.show("找不到 Synergy menu bar item")
    return
  end

  synergyToggleInProgress = true
  menuBarItem:performAction("AXPress")

  pressSynergyAction(menuBarItem, 10)
end


return toggleSynergy
