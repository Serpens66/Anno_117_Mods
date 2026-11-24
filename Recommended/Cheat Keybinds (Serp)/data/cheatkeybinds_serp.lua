-- Anno 117: the shortcut commands call this module initialized by modinfo.json.
-- See Documentation/mods/cheat-keybinds-audit.md for the Vanilla audit.
local CheatKeybinds_Serp = {
  ActiveCheat = 1,
  Loaded = false,
  -- Preserve the existing selection trigger IDs.
  NotificationGUIDs = {
    1500001201, 1500001202, 1500001203, 1500001204,
    1500001205, 1500001206, 1500001207, 1500001208,
    1500001209, 1500001210, 1500001211, 1500001212,
    1500001252, 1500001253,
  },
  FailureNotificationGUIDs = {
    goods_area = 1500001260,
    workforce_area = 1500001261,
    items_area = 1500001262,
    selection_missing = 1500001263,
    factory_selection = 1500001264,
    recruitment_selection = 1500001265,
    monument_selection = 1500001266,
    foreign_selection = 1500001267,
    research_empty = 1500001268,
    takeover_owned = 1500001269,
    participant_missing = 1500001270,
    emperor_missing = 1500001271,
    diplomacy_missing = 1500001272,
    workforce_unavailable = 1500001273,
  },
}

-- Result triggers use the same order as the cheat functions and selection notices.
local resultNotifications = {
  { -- Coins
    primary = 1500001341,
    alternative = 1500001361,
    failures = {
      generic = 1500002001,
    },
  },
  { -- All goods
    primary = 1500001342,
    alternative = 1500001362,
    failures = {
      generic = 1500002005,
      goods_area = 1500002006,
    },
  },
  { -- Workforce
    primary = 1500001343,
    alternative = 1500001363,
    failures = {
      generic = 1500002009,
      workforce_area = 1500002010,
      workforce_unavailable = 1500002011,
    },
  },
  { -- Building costs
    primary = 1500001344,
    failures = {
      generic = 1500002013,
    },
  },
  { -- Upgrades
    primary = 1500001345,
    failures = {
      generic = 1500002017,
    },
  },
  { -- Factory fertility
    primary = 1500001346,
    failures = {
      generic = 1500002021,
      selection_missing = 1500002022,
      factory_selection = 1500002023,
      foreign_selection = 1500002024,
    },
  },
  { -- Recruitment
    primary = 1500001347,
    failures = {
      generic = 1500002025,
      selection_missing = 1500002026,
      recruitment_selection = 1500002027,
      foreign_selection = 1500002028,
    },
  },
  { -- Monument
    primary = 1500001348,
    failures = {
      generic = 1500002029,
      selection_missing = 1500002030,
      monument_selection = 1500002031,
      foreign_selection = 1500002032,
    },
  },
  { -- Current research
    primary = 1500001349,
    alternative = 1500001369,
    failures = {
      generic = 1500002033,
      research_empty = 1500002034,
    },
  },
  { -- All research
    primary = 1500001350,
    alternative = 1500001370,
    failures = {
      generic = 1500002037,
    },
  },
  { -- Items
    primary = 1500001351,
    failures = {
      generic = 1500002041,
      items_area = 1500002042,
    },
  },
  { -- Ownership
    primary = 1500001352,
    failures = {
      generic = 1500002045,
      selection_missing = 1500002046,
      takeover_owned = 1500002048,
    },
  },
  { -- Emperor reputation
    primary = 1500001353,
    alternative = 1500001373,
    failures = {
      generic = 1500002049,
      participant_missing = 1500002050,
      emperor_missing = 1500002051,
    },
  },
  { -- Diplomacy cooldowns
    primary = 1500001354,
    failures = {
      generic = 1500002053,
      participant_missing = 1500002054,
      diplomacy_missing = 1500002055,
    },
  },
}

-- Capture the original stack inside the xpcall error handler.
local function errorTraceback(err)
  local message = tostring(err)
  if debug and debug.traceback then
    return debug.traceback(message, 2)
  end
  return message
end

local function logError(context, traceback)
  local message = "CheatKeybinds_Serp " .. context .. ": " .. traceback
  if system and system.logError then
    system.logError(message)
  else
    print(message)
  end
end

local function notify(guid)
  -- Notification-only triggers: never dispatch gameplay through ActionExecuteScript.
  local ok, err = xpcall(function()
    Conditions:RegisterTriggerForCurrentParticipantNet(guid)
  end, errorTraceback)
  if not ok then
    logError("notification " .. tostring(guid), err)
  end
end

local function selected(property)
  local object = Selection.Object
  if not object or not object:isValid() then
    return nil, "selection_missing"
  end
  if property and (not object[property] or not object[property]:isValid()) then
    return nil, string.lower(property) .. "_selection"
  end
  return object
end

local function ownedArea()
  if Area.IsCurrentAreaValidIsland then
    local area = Area.Current
    if area and area:isValid() and area.IsOwnedByCurrentParticipant then
      return area
    end
  end
  -- Also useful in menus when a building on the destination island is selected.
  local area = Area.CurrentSelectedArea
  if area and area:isValid() and area.IsOwnedByCurrentParticipant then
    return area
  end
  return nil
end

local function changeOwner()
  local object, reason = selected()
  if not object then return false, reason end
  if object.IsOwnedByCurrentParticipant then return false, "takeover_owned" end
  if object.IsKontor or (object.Villa and object.Villa:isValid()) then
    object.Area:Takeover(Participants.GetCurrentParticipantGUID, datasets.TakeOverTransformation.ChangeOwner)
  else
    Selection:ChangeParticipantOfSelected()
  end
  return true
end

-- Function values are intentional: no loadstring/eval or Anno 1800 ts wrappers.
-- The order matches the descriptions and explicit NotificationGUIDs above.
CheatKeybinds_Serp.Cheats = {
  function(alternative)
    Economy.MetaStorage:AddAmount(1010017, alternative and -100000 or 100000)
    return true
  end,
  function(alternative)
    local area = ownedArea()
    if not area then return false, "goods_area" end
    area.Economy:AddAmount(alternative and -1000 or 1000)
    return true
  end,
  function(alternative)
    -- AreaWorkforce resolves the current area implicitly; no selected-area fallback.
    if not Area.IsCurrentAreaValidIsland then return false, "workforce_area" end
    local area = Area.Current
    if not area or not area:isValid() or not area.IsOwnedByCurrentParticipant then return false, "workforce_area" end
    if not AreaWorkforce or not AreaWorkforce:isValid() then return false, "workforce_unavailable" end
    -- The native command defines the amount; this does not fill residences.
    AreaWorkforce:CheatChangeWorkforce(not alternative)
    return true
  end,
  function()
    Cheat.GlobalCheats:ToggleIgnoreBuildingCosts()
    return true
  end,
  function()
    Cheat.GlobalCheats:ToggleUpgradeCheck()
    return true
  end,
  function()
    local object, reason = selected("Factory")
    if not object then return false, reason end
    if not object.IsOwnedByCurrentParticipant then return false, "foreign_selection" end
    object.Factory:ToggleCheatFertility()
    return true
  end,
  function()
    local object, reason = selected("Recruitment")
    if not object then return false, reason end
    if not object.IsOwnedByCurrentParticipant then return false, "foreign_selection" end
    object.Recruitment:CheatSkipRemainingTime()
    return true
  end,
  function()
    local object, reason = selected("Monument")
    if not object then return false, reason end
    if not object.IsOwnedByCurrentParticipant then return false, "foreign_selection" end
    object.Monument:CheatUpgradeMicro()
    return true
  end,
  function(alternative)
    local tech = TechHandler:GetTechAtQueuePosition(0)
    if not tech or not tech.Guid or tech.Guid == 0 then return false, "research_empty" end
    if alternative then
      TechHandler:StopTech(tech.Guid)
    else
      TechHandler:CompleteTechResearch(tech.Guid, true)
    end
    return true
  end,
  function(alternative)
    if alternative then
      TechHandler:CheatResetAll()
    else
      TechHandler:CheatResearchAll()
    end
    return true
  end,
  function()
    -- This native cheat uses the current island, not CurrentSelectedArea.
    if not Area.IsCurrentAreaValidIsland then return false, "items_area" end
    local area = Area.Current
    if not area or not area:isValid() or not area.IsOwnedByCurrentParticipant then return false, "items_area" end
    Item:CheatAllItems()
    return true
  end,
  changeOwner,
  function(alternative)
    local participant = Participants.Current
    local emperor = Participants.ActiveEmperorProperty
    if not participant or not participant:isValid() then return false, "participant_missing" end
    if not emperor or not emperor:isValid() then return false, "emperor_missing" end
    -- Native ActionChangeReputation uses the trigger's processing participant.
    Conditions:RegisterTriggerForCurrentParticipantNet(alternative and 1500001257 or 1500001256)
    return true
  end,
  function()
    local participant = Participants.Current
    if not participant or not participant:isValid() then return false, "participant_missing" end
    local diplomacy = participant.Diplomacy
    if not diplomacy or not diplomacy:isValid() then return false, "diplomacy_missing" end
    diplomacy:ResetAllActionCooldownsNet()
    return true
  end,
}

function CheatKeybinds_Serp.GameLoaded()
  CheatKeybinds_Serp.ActiveCheat = 1
  CheatKeybinds_Serp.Loaded = true
end

function CheatKeybinds_Serp.GameUnloaded()
  CheatKeybinds_Serp.ActiveCheat = 1
  CheatKeybinds_Serp.Loaded = false
end

function CheatKeybinds_Serp.ChangeCheat(add)
  if not CheatKeybinds_Serp.Loaded then return end
  local ok, err = xpcall(function()
    add = add or 1
    CheatKeybinds_Serp.ActiveCheat = ((CheatKeybinds_Serp.ActiveCheat - 1 + add) % #CheatKeybinds_Serp.Cheats) + 1
    print("CheatKeybinds_Serp selected: " .. CheatKeybinds_Serp.ActiveCheat)
    notify(CheatKeybinds_Serp.NotificationGUIDs[CheatKeybinds_Serp.ActiveCheat])
  end, errorTraceback)
  if not ok then
    logError("selection", err)
  end
end

function CheatKeybinds_Serp.StartCheat(alternative)
  if not CheatKeybinds_Serp.Loaded then return end
  alternative = alternative == true
  local index = CheatKeybinds_Serp.ActiveCheat
  local direction = alternative and "alternative" or "normal"
  local notices = resultNotifications[index]
  local ok, result, reason = xpcall(CheatKeybinds_Serp.Cheats[index], errorTraceback, alternative)
  if not ok then
    logError("failed (" .. index .. ", " .. direction .. ")", result)
    notify(notices and notices.failures.generic or 1500001214)
  elseif result == false then
    print("CheatKeybinds_Serp not executed: " .. index .. " (" .. direction .. "): " .. tostring(reason))
    local failure = notices and (notices.failures[reason] or notices.failures.generic)
    notify(failure or CheatKeybinds_Serp.FailureNotificationGUIDs[reason] or 1500001213)
  else
    print("CheatKeybinds_Serp executed: " .. index .. " (" .. direction .. ")")
    local confirmation = notices and (alternative and notices.alternative or notices.primary)
    notify(confirmation or CheatKeybinds_Serp.NotificationGUIDs[index])
  end
end

return CheatKeybinds_Serp
