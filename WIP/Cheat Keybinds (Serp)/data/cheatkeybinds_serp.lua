print("cheatkeybinds_serp.lua: called (script to track GameClock:SetGameSpeed)")

-- TODO:
-- as soon as "Cheats" is implemented, maybe use Cheats:ShowOnScreenText(-6912019157524520777) to display the chosen cheat on screen

CheatKeybinds_Serp = {
  Cheats = { 
    1 = "ShipsBuff",
    2 = "Cheat.GlobalCheats:ToggleUpgradeCheck()", -- allows to upgrade all buildings which have an upgrade
    3 = "Cheat.GlobalCheats:ToggleIgnoreBuildingCosts()", -- no buildcosts for everything (costs are still subsctracted, so you can go bancrupt!)
    4 = "if Area.IsCurrentAreaValidIsland then Area.Current.Economy:AddAmount(1000) end;", -- credit 1000 of every unlocked good
    5 = "Economy.MetaStorage:AddAmount(1010017,100000)", -- money
    6 = "Selection.Object.Recruitment:CheatSkipRemainingTime()", -- instant ship/unit production of currently selected shipyards production
    7 = "Selection.Object.Monument:CheatUpgradeMicro()", -- finish a portion of selected monument building phase, hit multiple times to finish it
    8 = "AreaPopulation:CheatChangePopulation(true)", -- adds 500 of every unlocked residence to the global population (after unlock of new pop the amount is the same for all pops)
    9 = "TechHandler:CheatToggleResearchAll()", -- CompleteTechResearch or ResetTech for all existing techs
    10 = "ResearchCurrentTech", -- completes currently researched tech
    11 = "Selection.Object.Factory:ToggleCheatFertility()", -- add the needed fertility from the currently selected factory to the island
    12 = "Item:CheatAllItems()", -- add random items to the current island
    -- 13 = xxxx,
    -- 14 = xxxx,
    -- 15 = xxxx,
    -- 16 = xxxx,
    -- 17 = xxxx,
    -- 18 = xxxx,
    -- 19 = xxxx,
  },
  ActiveCheat = 1
}

-- Es gibt keine errors mehr im log scheinbar bei invalided lua code (also lua script immer auf syntax fehler selber prüfen!)
-- special cases not all split functions on the net can handle: seperator = "." and seperator = "Session" in Human0_Session_1234. Now this hopefully can handle both...

-- can be used as error_handler for xpcall. only within xpcall error_handler we can access the full traceback
-- usage: xpcall(fn,log_error,...)
function CheatKeybinds_Serp.log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("ERROR : "..fullerr)
  return fullerr
end


function CheatKeybinds_Serp.GameLoaded(self)
  print("cheatkeybinds_serp.lua: Game Loaded")
  local status,err = xpcall(function()
    CheatKeybinds_Serp.ActiveCheat = 1
  end,CheatKeybinds_Serp.log_error)
end
function CheatKeybinds_Serp.GameUnloaded(self)
  print("cheatkeybinds_serp.lua: Game Unloaded")
  local status,err = xpcall(function()
    CheatKeybinds_Serp.ActiveCheat = 1
  end,CheatKeybinds_Serp.log_error)
end

function CheatKeybinds_Serp.Main(self)
  -- print("cheatkeybinds_serp.lua: Main")
  -- local status,err = xpcall(function()

  -- end,CheatKeybinds_Serp.log_error)
end

function CheatKeybinds_Serp.ChangeCheat(self,add)
  print("cheatkeybinds_serp.lua: ChangeCheat ",add)
  local status,err = xpcall(function()
    if add==nil then
      add = 1
    end
    CheatKeybinds_Serp.ActiveCheat = CheatKeybinds_Serp.ActiveCheat + add
  end,CheatKeybinds_Serp.log_error)
end

function CheatKeybinds_Serp.StartCheat(self)
  print(11)
  local status,err = xpcall(function()
    print(22)
    activecheat = CheatKeybinds_Serp.Cheats[CheatKeybinds_Serp.ActiveCheat]
    print(33)
    print(activecheat)
    if activecheat=="ShipsBuff" then
      Conditions:RegisterTriggerForCurrentParticipantNet(1500000015)
    elseif activecheat=="Cheat.GlobalCheats:ToggleUpgradeCheck()" then
      Cheat.GlobalCheats:ToggleUpgradeCheck()
    elseif activecheat=="Cheat.GlobalCheats:ToggleIgnoreBuildingCosts()" then
      Cheat.GlobalCheats:ToggleIgnoreBuildingCosts()
    elseif activecheat=="if Area.IsCurrentAreaValidIsland then Area.Current.Economy:AddAmount(1000) end;" then
      if Area.IsCurrentAreaValidIsland then Area.Current.Economy:AddAmount(1000) end;
    elseif activecheat=="Economy.MetaStorage:AddAmount(1010017,100000)" then
      Economy.MetaStorage:AddAmount(1010017,100000)
    elseif activecheat=="Selection.Object.Recruitment:CheatSkipRemainingTime()" then
      Selection.Object.Recruitment:CheatSkipRemainingTime()
    elseif activecheat=="Selection.Object.Monument:CheatUpgradeMicro()" then
      Selection.Object.Monument:CheatUpgradeMicro()
    elseif activecheat=="AreaPopulation:CheatChangePopulation(true)" then
      AreaPopulation:CheatChangePopulation(true)
    elseif activecheat=="TechHandler:CheatToggleResearchAll()" then
      TechHandler:CheatToggleResearchAll()
    elseif activecheat=="ResearchCurrentTech" then
      local currentTech = TechHandler:GetTechAtQueuePosition(0);if currentTech and currentTech.Guid then TechHandler:CompleteTechResearch(currentTech.Guid, true);end
    elseif activecheat=="Selection.Object.Factory:ToggleCheatFertility()" then
      Selection.Object.Factory:ToggleCheatFertility()
    elseif activecheat=="Item:CheatAllItems()" then
      Item:CheatAllItems()
    -- elseif activecheat=="" then
      
    -- elseif activecheat=="" then
      
    -- elseif activecheat=="" then
      
    -- elseif activecheat=="" then
      
    -- elseif activecheat=="" then
      
    -- elseif activecheat=="" then
      
    -- elseif activecheat=="" then
      
    -- elseif activecheat=="" then
      
    end
    print("execute cheat: ",activecheat)
  end,CheatKeybinds_Serp.log_error)
end


return CheatKeybinds_Serp