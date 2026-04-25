-- Anno 117 does not allow to share/access any global variables from any script, not even ourself when we saved one and the script gets called again..
-- at least not for scripts executed with TriggerAction "ActionExecuteScript"

system.log("IncreaseGameSpeed script called")
-- GameClock:IncreaseGameSpeed() -- does nothing in MP



-- can be used as error_handler for xpcall. only within xpcall error_handler we can access the full traceback
-- usage: xpcall(fn,error_handler,...)
function log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("ERROR : "..fullerr)
  return fullerr
end

SaveSpeed = SaveSpeed or 2
local ValidGameSpeeds = {2,3,4} -- although in datasets.GameSpeed are more, GameClock:SetGameSpeed(newspeed) does not accept them in MP ...

function IncreaseGameSpeed()
  system.log("IncreaseGameSpeed function called")
  
  Pause:IncreaseGameSpeed()
  
  
  -- local currentspeed = SaveSpeed -- GameClock.GameSpeed does not work for multiplayer, always returns 2...
  -- system.log("IncreaseGameSpeed currentspeed is "..tostring(currentspeed))
  -- local newspeed = currentspeed+1
  -- system.log("IncreaseGameSpeed try new speed: "..tostring(newspeed))
  -- if ValidGameSpeeds[newspeed]~=nil then
    -- GameClock:SetGameSpeed(newspeed)
    -- system.log("IncreaseGameSpeed new speed is now: "..tostring(newspeed))
    -- SaveSpeed = newspeed
  -- end
  system.log("IncreaseGameSpeed function done")
end

xpcall(IncreaseGameSpeed,log_error)