print("testscript called from xml start")

-- https://luau.org/

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


