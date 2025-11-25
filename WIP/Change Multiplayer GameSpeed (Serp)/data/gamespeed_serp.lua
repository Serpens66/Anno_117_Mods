print("gamespeed_serp.lua: called (script to track GameClock:SetGameSpeed)")

-- GameClock:SetGameSpeed will be used for Multiplayer only (Singlepayer uses "Pause:" instead)

GameSpeed_Serp = {CurrentGameSpeed=2,ValidGameSpeeds={}}

-- Es gibt keine errors mehr im log scheinbar bei invalided lua code (also lua script immer auf syntax fehler selber prüfen!)


-- can be used as error_handler for xpcall. only within xpcall error_handler we can access the full traceback
-- usage: xpcall(fn,error_handler,...)
local function log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("ERROR : "..fullerr)
  return fullerr
end
function GameSpeed_Serp.log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("ERROR : "..fullerr)
  return fullerr
end


function GameSpeed_Serp.GameLoaded(self)
  print("gamespeed_serp.lua: Game Loaded")
  local status,err = xpcall(function()
    GameSpeed_Serp.CurrentGameSpeed = 2
    t = 1/0 + z
  end,GameSpeed_Serp.log_error)
end
function GameSpeed_Serp.GameUnloaded(self)
  print("gamespeed_serp.lua: Game Unloaded")
  local status,err = xpcall(function()
    GameSpeed_Serp.CurrentGameSpeed = 2
  end,GameSpeed_Serp.log_error)
end

function GameSpeed_Serp.Main(self)
  print("gamespeed_serp.lua: Main")
  local status,err = xpcall(function()
    for k,v in pairs(datasets.GameSpeed) do
      if k~="Invalid" and k~="Count" then
        GameSpeed_Serp.ValidGameSpeeds[v] = k
      end
    end
  end,log_error)
end

function GameSpeed_Serp.SetGameSpeed(self,gamespeed)
  local status,err = xpcall(function()
    if GameSpeed_Serp.ValidGameSpeeds[gamespeed]~=nil then
      GameClock:SetGameSpeed(gamespeed)
      GameSpeed_Serp.CurrentGameSpeed = gamespeed -- remember the current set speed
      print("gamespeed_serp.lua: GameClock GameSpeed set to: "..tostring(gamespeed).." = "..tostring(GameSpeed_Serp.ValidGameSpeeds[gamespeed]))
    end
  end,GameSpeed_Serp.log_error)
end

GameSpeed_Serp2 = 5

return GameSpeed_Serp