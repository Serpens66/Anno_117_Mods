print("testscript_main called")
system.log("testscript_main called")
local TestMod = {Last_Tick=0}

-- https://luau.org/
-- debug.info(v,"snlaf") -- https://rfcs.luau.org/function-debug-info.html

-- can be used as error_handler for xpcall. only within xpcall error_handler we can access the full traceback
-- xpcall(fn,error_handler,...)
local function log_error(err)
  local traceback = debug.traceback~=nil and debug.traceback() or "nil"
  local fullerr = tostring(err)..", traceback:\n"..traceback
  system.log("LUA ERROR : "..fullerr)
  return fullerr
end



function TestMod.Tick()
  local status,err = xpcall(function()
    local gametime = GameClock.CorporationTime
    -- print("Tick",gametime,TestMod.Last_Tick,type(gametime))
    if gametime~=nil and gametime~=0 and type(gametime)=="number" then
      if gametime - TestMod.Last_Tick > 10000 then -- if last execution is more than 10 seconds ago
        TestMod.Last_Tick = gametime
        -- print(Selection:isValid())
        if Selection:isValid() and Selection.Object:isValid() then
          print("Tick",Selection.Object.GUID)
          if Selection.Object.ShipModuleOwner:isValid() then -- funzt iwie noch nicht..
            -- Selection.Object.ShipModuleOwner:CheatAddShipModule(31651)
            Selection.Object.ShipModuleOwner:CheatTryRemoveShipModule(31651)
            print("ShipModuleOwner CheatTryRemoveShipModule")
          else
            print("invalid ShipModuleOwner")
          end
        end
      end
    end
  end,log_error)
end

-- it is called when starting the transition to the session. the player might be stuck for another 10 seconds or so in loading screen...
local function OnSessionEnterFn(SessionLoadedContext)
  local status,err = xpcall(function()
    print("Session Entered")
    -- print(SessionLoadedContext.SessionID) -- seems only SessionGUID has a value, the others are emtpy..
    print(SessionLoadedContext.SessionGUID,SessionLoadedContext.IsNewSession,SessionLoadedContext.SessionID,SessionLoadedContext.AllSessionsLoaded)
    TestMod.Main()
  end,log_error)
end

function TestMod.GameLoaded()
  print("Game Loaded")
  system.log("Game Loaded")
  local status,err = xpcall(function()
    -- Options.SetExtendedCameraDistanceEnabled(true) -- seems not to exist anymore as function...
    -- if events.OnSessionEnter["testscript"]==nil then
      -- events.OnSessionEnter:Add(OnSessionEnterFn,"testscript")
      -- print("OnSessionEnterFn registered")
    -- else -- TODO: sichergehen dass dieser check funzt
      -- print("OnSessionEnterFn already registered")
    -- end
        
  end,log_error)
end
function TestMod.GameUnloaded()
  print("Game Unloaded")
end

print("Hier0")
function TestMod.Main()
  local status,err = xpcall(function()

      
      -- print(_VERSION) -- lua version: Luau ist eine von Lua 5.1 abgeleitete Skriptsprache, die speziell für Roblox entwickelt wurde und in Roblox Studio verwendet wird. Sie ist bekannt für ihre Geschwindigkeit, Sicherheit und schrittweise Typisierung
      
      
      -- and we can not use global variables in different scripts anymore?!
    
  -- funktioniert nicht mehr vanilla funktionen zu überschreiben... no writable member 'SetGameSpeed'
  -- local SetGameSpeed_old = GameClock.SetGameSpeed -- overwriting this to be notified whenever it is called anywhere, even other mods
  -- GameClock.SetGameSpeed = function(self, gameSpeed) -- no need to do it for IncreaseGameSpeed/DecreaseGameSpeed because they dont work well anyways (once slowest is reached, you can not increase anymore, so no modder should use them anyways)
    -- print("gamespeed_serp.lua : GameClock:SetGameSpeed called with: "..tostring(gameSpeed))
    -- GameSpeed_Serp.CurrentGameSpeed = gameSpeed
    -- return SetGameSpeed_old(gameSpeed)
  -- end
      
      
      
      
      

      -- datasets.RomanizationType.None
      -- man kann nun auch direkt auf datasets zugreifen :)

      -- print()
      -- wird jetzt auch im offizeillen log angezeigt:
      -- [17:11:20][369020][SCRIPT][    DEBUG] [Lua: Action] @data/testscript.lua(1): testscript called
      -- können nun aber auch: system.log(finalOutput) verwenden
      -- (am besten modlog dann system.log nutzen, aber eben ModID noch in string zufügen)

      -- Es gibt keine errors mehr im log scheinbar bei invalided lua code oderso



      local ModID = "testmod"
      -- if g_LTL_Serp==nil then
        -- run("data/scripts_serp/lighttools.lua")
      -- end



      -- ##########################################################################################################################################################
      -- ##########################################################################################################################################################
      -- local function OnLeaveUIState(a)
        -- print("OnLeaveUIState: "..tostring(a))
        -- system.log("OnLeaveUIState: "..tostring(a))
      -- end
      -- if added_OnLeaveUIState==nil then -- only add it once
        -- table.insert(event.OnLeaveUIState, OnLeaveUIState)
        -- added_OnLeaveUIState = true
        -- system.log("registered OnLeaveUIState")
      -- else
        -- system.log("already registered OnLeaveUIState")
      -- end


      -- system.log(g_LTL_Serp.TableToFormattedString(getmetatable(ts.Selection.Object)))


      -- Area.ConstructionArea.Fertilities

      -- MetaObjects.GetSessionGameObject(ID)

      -- MetaGame.GetActiveSessionGUIDOfPeerInt(peer)
      -- userdata = Script.getObjectByID(8589934623)
      -- Online.GetCoopPeersAtMarker(id , customValue )
      -- Cheats:UnloadSession(GUID)

      -- Selection.Object.Position -- Vector3: 0x1fcbc1334b8

      -- Cheats:ToggleConsole()
      
      -- print(Participants.GetCurrentParticipantGUID) -- GUID 41
      -- Cheats:SpawnGameObject(37223 , Participants.GetCurrentParticipantGUID , true )

      -- testen ob speichern von object in varialbe noch immer broken ist, wenn mans nochmal abfragt
      -- local object = Selection.Object
      -- system.log(object.Position)
      -- system.log(object.Owner)
      -- system.log(object.GUID)
      -- keine Ahnung warum ich für fast alles so ne Meldung bekomme...
      -- ERROR : Weak reference to CSelectionManager was null 
      -- system.log(Selection.Object.GUID)
      -- system.log(Selection.Object.MetaObjectID)
      -- system.log(Selection.Object.ID)


      -- globals = {Account=Account,AccountSettings=AccountSettings,Achievements=Achievements,ActiveTrade=ActiveTrade,Activities=Activities,AiConstruction=AiConstruction,AiUnit=AiUnit,Animals=Animals,AppLifeCycleFlow=AppLifeCycleFlow,AreaBuildabilityGrid=AreaBuildabilityGrid,AreaFetch=AreaFetch,Incidents=Incidents,Area=Area,AreaManager=AreaManager,AreaNeedAttributes=AreaNeedAttributes,AreaNeedUnlock=AreaNeedUnlock,AreaPopulation=AreaPopulation,AreaReligion=AreaReligion,AreaResidenceConsumption=AreaResidenceConsumption,AreaTakeoverManager=AreaTakeoverManager,AreaWorkforce=AreaWorkforce,Assert=Assert,ToolOneDataHelper=ToolOneDataHelper,AssetDataManager=AssetDataManager,AutomatedTest=AutomatedTest,Benchmark=Benchmark,Blueprint=Blueprint,BuildMode=BuildMode,SessionCamera=SessionCamera,CameraSequenceManager=CameraSequenceManager,Cheats=Cheats,Cheat=Cheat,Cinematics=Cinematics,Conditions=Conditions,Variables=Variables,Contracts=Contracts,CoopLateJoin=CoopLateJoin,DlcUpgrade=DlcUpgrade,Daytime=Daytime,DebugInfo=DebugInfo,DebugRender=DebugRender,DesyncRecover=DesyncRecover,Diplomacy=Diplomacy,Discovery=Discovery,Economy=Economy,EconomyStatistic=EconomyStatistic,EngineMetrics=EngineMetrics,Environment=Environment,SavegameFetcher=SavegameFetcher,FrameGrabber=FrameGrabber,FullscreenMovieQueueManager=FullscreenMovieQueueManager,GameClock=GameClock,Game=Game,Objects=Objects,GamepadActionManager=GamepadActionManager,RuntimeSettings=RuntimeSettings,GameSession=GameSession,GameSetup=GameSetup,GovernorDecision=GovernorDecision,HallOfFame=HallOfFame,HappyDayEventManager=HappyDayEventManager,InfoTip=InfoTip,Input=Input,Irrigation=Irrigation,Island=Island,Item=Item,Language=Language,LoadingPier=LoadingPier,Memorize=Memorize,MemoryTracking=MemoryTracking,MetaEffects=MetaEffects,MetaGame=MetaGame,MetaObjects=MetaObjects,MetaIncidents=MetaIncidents,Money=Money,TechHandler=TechHandler,Religion=Religion,Unit=Unit,Mods=Mods,MouseManager=MouseManager,Notifications=Notifications,ObjectSpawn=ObjectSpawn,Online=Online,Options=Options,Participants=Participants,Path=Path,Pause=Pause,PerformanceTracking=PerformanceTracking,Pins=Pins,Population=Population,Popup=Popup,Quests=Quests,Regrow=Regrow,RemoteImage=RemoteImage,Rewards=Rewards,Romanization=Romanization,Savegame=Savegame,Scenarios=Scenarios,Scripts=Scripts,Season=Season,Selection=Selection,SessionAqueduct=SessionAqueduct,AreaCoast=AreaCoast,Cooldown=Cooldown,SessionEffects=SessionEffects,Feedback=Feedback,FreeAreaProductivity=FreeAreaProductivity,MiscRender=MiscRender,SessionParticipants=SessionParticipants,Street=Street,SessionUnit=SessionUnit,ShipModuleConfiguration=ShipModuleConfiguration,ShortcutManager=ShortcutManager,Slot=Slot,Sound=Sound,StreetOverlay=StreetOverlay,Target=Target,Text=Text,ToolOneHelper=ToolOneHelper,TradeRoute=TradeRoute,Unlock=Unlock,Weather=Weather,WinLose=WinLose,World=World,WorldMap=WorldMap,Static=Static}
      -- for k,v in pairs(globals) do
        -- print(k,help(v)) -- returned das was auch in den lua scripten vom game als ---@field drinsteht.
        -- print("############")
        -- print(k,inspect(v)) -- does not work yet, maybe needs a fix
      -- end

      
      -- TEST:
      -- ob man globale variablen im script überschreiben kann und diese dann auch in text textsource ihr geändertes verhalten haben
       -- (vermutlich nicht)    
      print("Main")
      print("isValid: ",Selection:isValid())
      print("Object isValid: ",Selection.Object:isValid())

      print(session~=nil)
      print(game~=nil)
      
      -- scheint kein userdata und daher auch kein userdata:changeGUID mehr zu geben, nur noch selected...
      -- Cheats:ReplaceSelected(GUID)
      -- Eine globle Liste von Properties gibts, aber keine für Participants GUIDs. 31099 ist Dorian und 41 Human0
      -- local objects = Scripts:GetObjectGroupByProperty(Properties.Movement) -- loop thorugh all moveable units. defaults to local player as owner
      -- local objects = Scripts:GetObjectGroupByProperty(Properties.Movement,31099) -- loop thorugh all moveable units. defaults to local player as owner
      -- for _,gameobject in pairs(objects) do -- ist keine userdata mehr, sondern GameObject
        -- print(gameobject.GUID,gameobject.Owner,gameobject.ID,gameobject.MetaGameObjectID) -- 5473 31099 4294967303 -> eine ID ist noch leer
        -- print(gameobject.Nameable.Name)
      -- end
      
      print(Cheats==nil) -- ist aktuell noch nil
      TableToFormattedString(Cheats)
      
      -- Cheats:SpawnGameObject(5473,41,true)
      -- Cheats:SpawnGameObject(5473,41,false,rdmath.Vector3(100, 100, 100))

      
  end,log_error)
  -- if status==false then
    -- error(err)
  -- end
end

print("finished loading")
return TestMod