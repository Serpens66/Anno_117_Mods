-- Anno 117: the shortcut commands call this module initialized by modinfo.json.
-- See Documentation/reference/cheat-keybinds-audit.md for the Vanilla audit.
local CheatKeybinds_Serp = {
  ActiveCheat = 1,
  Loaded = false,
  -- Keep existing notification IDs, especially the separate error notices 1213/1214.
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

local function notify(guid)
  -- Notification-only triggers: never dispatch gameplay through ActionExecuteScript.
  local ok, err = pcall(function()
    Conditions:RegisterTriggerForCurrentParticipantNet(guid)
  end)
  if not ok then
    print("CheatKeybinds_Serp notification: " .. tostring(err))
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
  add = add or 1
  CheatKeybinds_Serp.ActiveCheat = ((CheatKeybinds_Serp.ActiveCheat - 1 + add) % #CheatKeybinds_Serp.Cheats) + 1
  print("CheatKeybinds_Serp selected: " .. CheatKeybinds_Serp.ActiveCheat)
  notify(CheatKeybinds_Serp.NotificationGUIDs[CheatKeybinds_Serp.ActiveCheat])
end

function CheatKeybinds_Serp.StartCheat(alternative)
  if not CheatKeybinds_Serp.Loaded then return end
  alternative = alternative == true
  local index = CheatKeybinds_Serp.ActiveCheat
  local direction = alternative and "alternative" or "normal"
  local ok, result, reason = pcall(CheatKeybinds_Serp.Cheats[index], alternative)
  if not ok then
    print("CheatKeybinds_Serp failed (" .. index .. ", " .. direction .. "): " .. tostring(result))
    notify(1500001214)
  elseif result == false then
    print("CheatKeybinds_Serp not executed: " .. index .. " (" .. direction .. "): " .. tostring(reason))
    notify(CheatKeybinds_Serp.FailureNotificationGUIDs[reason] or 1500001213)
  else
    print("CheatKeybinds_Serp executed: " .. index .. " (" .. direction .. ")")
    notify(CheatKeybinds_Serp.NotificationGUIDs[index])
  end
end

return CheatKeybinds_Serp
