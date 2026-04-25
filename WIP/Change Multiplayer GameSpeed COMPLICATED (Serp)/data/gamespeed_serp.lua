print("gamespeed_serp.lua: called")

-- GameClock:SetGameSpeed will be used for Multiplayer only (Singlepayer uses "Pause:" instead)



GameSpeed_Serp = {
  CurrentGameSpeed=2,
  ValidGameSpeeds={[2]=true,[3]=true,[4]=true}, -- although in datasets.GameSpeed are more, GameClock:SetGameSpeed(newspeed) does not accept them in MP ...
  LastCheckTime=0,
  added_OnLeaveUIState=nil,
}

-- Es gibt keine errors mehr im log scheinbar bei invalided lua code (also lua script immer auf syntax fehler selber prüfen!)
-- can be used as error_handler for xpcall. only within xpcall error_handler we can access the full traceback
-- usage: xpcall(fn,error_handler,...)
function GameSpeed_Serp.log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("ERROR : "..fullerr)
  return fullerr
end

function GameSpeed_Serp.OnLeaveUIState(a)
  system.log("OnLeaveUIState (MP speed mod): "..tostring(a))
  if tostring(a)=="[GamePause]" then -- only triggered on leaving the ESC menu, not when leaving the actual Pause via the Pause button...
    GameSpeed_Serp.CurrentGameSpeed = 2 -- reset
    if Conditions:isValid() then
      Conditions:RegisterTriggerForCurrentParticipantNet(1500000054) -- reset the variable CurrentGameSpeed_MP_Serp to 2 again (not possible in lua, must be xml...but xml also syncs it luckily)
    end
  end
end

function GameSpeed_Serp.GameLoaded(self)
  print("gamespeed_serp.lua: Game Loaded")
  local status,err = xpcall(function()
    GameSpeed_Serp.CurrentGameSpeed = 2 -- reset
    GameSpeed_Serp.LastCheckTime = 0 -- reset
    if Conditions:isValid() then
      Conditions:RegisterTriggerForCurrentParticipantNet(1500000054) -- reset the variable CurrentGameSpeed_MP_Serp to 2 again (not possible in lua, must be xml...but xml also syncs it luckily)
    end
    if GameSpeed_Serp.added_OnLeaveUIState==nil then -- only add it once
      table.insert(event.OnLeaveUIState, GameSpeed_Serp.OnLeaveUIState)
      GameSpeed_Serp.added_OnLeaveUIState = true
    end
  end,GameSpeed_Serp.log_error)
end
function GameSpeed_Serp.GameUnloaded(self)
  print("gamespeed_serp.lua: Game Unloaded")
  local status,err = xpcall(function()
    GameSpeed_Serp.CurrentGameSpeed = 2 -- reset
    GameSpeed_Serp.LastCheckTime = 0 -- reset
  end,GameSpeed_Serp.log_error)
end


function GameSpeed_Serp.Tick_CheckIfSpeedShouldChange(self)
  local status,err = xpcall(function()
    local gametime = GameClock.PlayTime
    if gametime~=nil and gametime~=0 and type(gametime)=="number" then
      if gametime - GameSpeed_Serp.LastCheckTime > 1000 then -- if last execution is more than 10 seconds ago
        GameSpeed_Serp.LastCheckTime = gametime
        
        if Variables:isValid() then
          -- since we only check a variable value here every tick, it should be fine doing it every tick. no need to only do it like every x seconds by checking PlayTime
          system.log("Variable value is: global: "..tostring(Variables:GetVariable("CurrentGameSpeed_MP_Serp")))
          system.log(" participant: "..tostring(Variables:GetVariableForParticipant("CurrentGameSpeed_MP_Serp",Participants.GetCurrentParticipantGUID)))
          local newspeed = tonumber(Variables:GetVariable("CurrentGameSpeed_MP_Serp")) -- 0 by default, will be set via xml trigger keybind, and is synced to all players
          if GameSpeed_Serp.CurrentGameSpeed~=newspeed then
            system.log("currentspeed is "..tostring(GameSpeed_Serp.CurrentGameSpeed))
            system.log("try new speed: "..tostring(newspeed))
            if GameSpeed_Serp.ValidGameSpeeds[newspeed]~=nil then -- is made sure in xml already that it only can be between 2 and 4
              GameClock:SetGameSpeed(newspeed)
              system.log("new speed is now: "..tostring(newspeed))
              GameSpeed_Serp.CurrentGameSpeed = newspeed -- remember the current set speed
            else
              system.log("ERROR: newspeed saved in xml variable is invalid: "..tostring(newspeed))
            end
          end
          
        end
      end
    end
  end,GameSpeed_Serp.log_error)
end


return GameSpeed_Serp