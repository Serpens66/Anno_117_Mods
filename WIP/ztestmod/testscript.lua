print("testscript called from xml start")

-- can be used as error_handler for xpcall. only within xpcall error_handler we can access the full traceback
-- xpcall(fn,error_handler,...)
local function log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("ERROR : "..fullerr)
  return fullerr
end


local status,err = xpcall(function()
  print("testscript called from xml")
    
  

    
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


