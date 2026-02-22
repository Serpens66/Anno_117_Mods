print("testscript called from xml start")

-- https://luau.org/

-- can be used as error_handler for xpcall. only within xpcall error_handler we can access the full traceback
-- xpcall(fn,error_handler,...)
local function log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("LUA ERROR : "..fullerr)
  return fullerr
end


-- Areatable is a table (eg returned from Object.Area.ID/ts.Area.Current.ID eg. AreaID={SessionID=2,IslandID=1,AreaIndex=1})
function AreatableToAreaID(Areatable)
  if type(Areatable)=="table" then
    local AreaIndex,IslandID,SessionID = Areatable["AreaIndex"],Areatable["IslandID"],Areatable["SessionID"]
    if type(AreaIndex)=="number" and type(IslandID)=="number" and type(SessionID)=="number" then
      local AreaID = (bit32.lshift(AreaIndex,13)+bit32.lshift(IslandID,6)+SessionID)
      return AreaID
    end
  end
end
function AreaIDToAreatable(AreaID)
  if type(AreaID)~="table" then
    local AreaIndex = bit32.rshift(bit32.band(AreaID,0xE000), 13)
    local IslandID = bit32.rshift(bit32.band(AreaID,0x1FC0), 6)
    local SessionID = bit32.band(AreaID,0xF)
    return {AreaIndex=AreaIndex, IslandID=IslandID, SessionID=SessionID}
  end
end

-- only returns valid areas from the currently active session of the executing player
-- MetaGame.GetSessionGameObject(OID) is able to return objects from any session! 
-- see also compare to 1800: https://github.com/Serpens66/Anno-1800-SharedMods-for-Modders-/blob/3aece64f299365309aaf1f7a57f28e2f6900f106/shared_LuaLight/data/scripts_serp/lighttools.lua#L752
-- and : https://github.com/Serpens66/Anno-1800-Mods/blob/2869e3bdade294b068718b91cd811ac2816db099/WorkInProgress-Mods/shared_LuaMedium/data/scripts_serp/objectfinder.lua#L493
function LoopOverAllAreas()
  print("called LoopOverAllAreas")
  FromSessionID = 1 -- 0 is meta
  ToSessionID = 40
  FromIslandID = 1 -- is 0 for eg. ships and other things not bound to islands
  ToIslandID = 100
  FromAreaIndex = 1 -- is 0 for eg. ships and other things not bound to islands
  ToAreaIndex = 1 -- can be 2 for islands sharing two owners , like ketema island. but unlikely that we need it, so default to only 1
  for SessionID=FromSessionID,ToSessionID do
    for IslandID=FromIslandID,ToIslandID do
      for AreaIndex=FromAreaIndex,ToAreaIndex do
        local AreaID = AreatableToAreaID({SessionID=SessionID,IslandID=IslandID,AreaIndex=AreaIndex})
        local theArea = GameSession:AreaFromID(AreaID) -- Area or GameSession, both have AreaFromID, seems to be no difference
        -- local theArea = Area:AreaFromID(AreaID)
        if theArea and theArea:isValid() then
          local KontorID = theArea.KontorID
          local OwnerName = theArea.OwnerName
          local Owner = theArea.Owner
          local KontorCost = theArea.KontorCost
          local Fertilities = theArea.Fertilities
          local CityName = theArea.CityName
          local HasAreaEconomy = theArea.HasAreaEconomy
          print(SessionID,AreaID,KontorID,OwnerName,Owner,KontorCost,Fertilities,CityName,HasAreaEconomy)
        end
      end
    end
  end
end


local status,err = xpcall(function()
  print("testscript called from xml")
  system.log("testscript called from xml")
  LoopOverAllAreas()
    
    -- Target:ToggleTargetMode(2001000) -- move
    -- Target:ToggleTargetMode(2001296) -- attack
    
    -- nachdem TargetMode auch fremde erlaubt, kann man damit wieder KI schiffe befehligen.
     -- Allerdings scheint man im Modus festzustecken, man kann kamera nicht mehr bewegen und jedes schiff befehligen was man anklickt..
    
    
    
    -- Cheats:ShowOnScreenText("test")
    -- Cheats:ShowOnScreenText(31722)
    -- Cheats:ShowOnScreenText(-6912019157524520777)

    
  -- MetaEffects:CheatStartEffectNet(51354,41) -- kann nur zufügen, nicht entfernen. und scheinbar kein Weg, weder xml noch lua, zu testen ob ein Effekt aktiv ist
  
  -- print(AssetData(37224).Icon)
  
  -- Notifications:PlayProfileNotificationFromOasisID(31722 , "-6912019157524520777" ) -- portrait erscheint, aber kein text, egal ob beliebiger text oder subtitle (auch nicht wenn passend, auch nicht UGID einer CharacterNotification)
  -- Notifications:PlayProfileNotificationFromOasisID(31722 , 6912019157524520777 ) -- wenn positive zahl (egal ob existent oder nicht), erscheint auch ein Text Feld, aber weiterhin kein text
  
    
  -- Cheats:ShowCharacterNotification(-6912019157524520777) -- Cheats geht noch nicht
  -- Cheats:ShowNotification(41869)
    
  -- Cheats:StartBuildMode(3528) -- funzt nicht
  -- BuildMode:SetBuildMode(3528,false) -- funzt, aber locked kann nichtmal als blueprint gebaut werden -.-
  -- Scripts:StartBuild(3528) -- funzt nur wenn unlocked
  -- AutomatedTest:StartBuildMode(3528) -- funzt nur wenn unlocked
  -- startMouseMode scheint es nicht mehr zu geben... also kein attackmode mehr aktivierbar usw.?! auch kein pipette mode
    
  -- print(datasets.GameSpeed)
    
  -- print(Participants.Current.ProfileCounter.Stats:GetCounter(0 , 36 , 40562 , 3 ))
    
  -- Conditions:RegisterTriggerForCurrentParticipantNet(1500001011)
  
  -- GameClock:SetGameSpeed(4)
  
  -- print(Selection.Object.Position)  
  
  -- print(Cheat:isValid()) 
  -- Item:CheatAllItems()
  -- Unlock:UnlockNet(2880)
  
  -- local currentTech = TechHandler:GetTechAtQueuePosition(0);if currentTech and currentTech.Guid then TechHandler:CompleteTechResearch(currentTech.Guid, true);end
  
  -- Cheat.GlobalCheats:ToggleIgnoreFertilities()
  
  -- Economy.MetaStorage:AddAmount(1010017,1000)
  -- print("Mainnn")
  -- print("isValid: ",Selection:isValid())
  -- print("Object isValid: ",Selection.Object:isValid())
  -- print("Mainnn",Selection.Object.GUID)
  -- Selection.Object.ShipModuleOwner:CheatAddShipModule(31651)
  -- Selection.Object.ShipModuleOwner:CheatTryRemoveShipModule(31651)
  
  -- print(Area.Current.Fertilities)
  -- for k,v in pairs(getmetatable(Cheats)) do
  -- for k,v in pairs(Unlock) do
    -- print(k,v)
  -- end
  
end,log_error)


