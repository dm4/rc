local applicationShortcuts = {
  ["opt+cmd+\\"] = "1Password",
  ["opt+i"] = "ChatGPT",
  ["opt+u"] = "Claude",
  ["opt+v"] = "com.microsoft.VSCode", -- Visual Studio Code / Code
  ["opt+f"] = "Fantastical",
  ["opt+b"] = "Google Chrome",
  ["opt+l"] = "LINE",
  ["opt+d"] = "Obsidian",
  ["opt+s"] = "Slack",
  ["opt+g"] = "Telegram",
  ["opt+e"] = "Thunderbird",
  ["opt+p"] = "Typora",
  ["opt+t"] = "WezTerm",
  ["opt+r"] = "com.apple.reminders", -- 提醒事項
  ["opt+y"] = "Ivory",
}

local modifierAliases = {
  alt = "alt",
  cmd = "cmd",
  command = "cmd",
  control = "ctrl",
  ctrl = "ctrl",
  opt = "alt",
  option = "alt",
  shift = "shift",
}

local function parseShortcut(shortcut)
  local parts = {}

  for part in shortcut:gmatch("[^+]+") do
    table.insert(parts, part)
  end

  local key = table.remove(parts)
  assert(key, "Shortcut must include a key: " .. shortcut)

  local modifiers = {}
  for _, part in ipairs(parts) do
    local modifier = modifierAliases[part]
    assert(modifier, "Unknown shortcut modifier: " .. part)
    table.insert(modifiers, modifier)
  end

  return modifiers, key
end


local function toggleApplication(applicationName)
  local application = hs.application.find(applicationName, true, true)

  if application and application:isFrontmost() then
    application:hide()
    return
  end

  hs.application.open(applicationName)
end


for shortcut, applicationName in pairs(applicationShortcuts) do
  local modifiers, key = parseShortcut(shortcut)
  local currentApplicationName = applicationName

  hs.hotkey.bind(modifiers, key, function()
    toggleApplication(currentApplicationName)
  end)
end
