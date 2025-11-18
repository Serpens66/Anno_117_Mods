print("testscript called from xml1")

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
  Economy.MetaStorage:AddAmount(1010017,10000)
  print("Mainnn")
  print("isValid: ",Selection:isValid())
  print("Object isValid: ",Selection.Object:isValid())
  print("Mainnn",Selection.Object.GUID)
  -- Selection.Object.ShipModuleOwner:CheatAddShipModule(31651)
  -- Selection.Object.ShipModuleOwner:CheatTryRemoveShipModule(31651)
  
  -- print(Area.Current.Fertilities)
  -- for k,v in pairs() do
    -- print(k,v)
  -- end
  
end,log_error)
