"""Structural checks and generation of a standalone Luau mock test; no game claims.

Resolve configured paths from Documentation/local.json. Execute the generated
.luau with the workspace's permission route. Output stays in Documentation/out.
"""
from pathlib import Path
import json
import re
import copy
from itertools import product
from lxml import etree as ET

root = Path(__file__).resolve().parents[2]
mod = root / 'Recommended/Cheat Keybinds (Serp)'
config_path = root / 'Documentation/local.json'
setup_hint = 'See Documentation/setup.md and Documentation/local.example.json.'
try:
    config = json.loads(config_path.read_text(encoding='utf-8-sig'))
except (OSError, ValueError) as error:
    raise SystemExit(f'Cannot read Documentation/local.json: {error}. {setup_hint}')
if not isinstance(config, dict):
    raise SystemExit(f'Documentation/local.json must contain a JSON object. {setup_hint}')


def configured_path(key, required=True):
    value = config.get(key, '')
    if not isinstance(value, str):
        raise SystemExit(f'Configuration field {key} must be a path string. {setup_hint}')
    if not value.strip():
        if required:
            raise SystemExit(f'Configuration field {key} is not configured. {setup_hint}')
        return None
    return (config_path.parent / value).resolve()


vanilla = configured_path('vanillaPath')
if not vanilla.is_dir():
    raise SystemExit(f'Configuration field vanillaPath must point to an existing extract. {setup_hint}')
console_mod = configured_path('consoleModPath', required=False)
if console_mod is None:
    console_mod = configured_path('modsPath') / 'console-ubi'
if not (console_mod / 'data/base/config/export/assets.xml').is_file():
    raise SystemExit(
        f'Console source assets.xml is missing. Set consoleModPath to the package root '
        f'or modsPath to its parent directory. {setup_hint}')
for native_name in ('assets.xml', 'templates.xml'):
    if not (vanilla / 'data/base/config/export' / native_name).is_file():
        raise SystemExit(
            f'Configuration field vanillaPath is missing data/base/config/export/{native_name}. '
            f'{setup_hint}')

native = ET.parse(str(vanilla / 'data/base/config/export/assets.xml'))
patch = ET.parse(str(mod / 'data/base/config/export/assets.xml'))
asset = native.xpath("//Asset[Values/Standard/GUID='2001271']")
assert len(asset) == 1 and asset[0].findtext('Template') == 'ShortcutConfig'
assert len(asset[0].xpath("Values/ShortcutConfig/InputBindings/Item[InputTypes/Modern/KeyType='Alt;F4']")) == 1
assert len(native.xpath("//Asset[Values/Standard/GUID='31973']")) == 1
assert len(patch.xpath('//Asset')) == 32
ids = patch.xpath('//Asset/Values/Standard/GUID/text()')
assert len(ids) == len(set(ids)) == 32
assert set(map(int, ids)) == set(range(1500001201, 1500001215)) | {1500001252, 1500001253, 1500001256, 1500001257} | set(range(1500001260, 1500001274))
native_ids = set(native.xpath('//Asset/Values/Standard/GUID/text()'))
assert not set(ids) & native_ids
for other in root.rglob('*.xml'):
    if mod in other.parents or root / 'Documentation/out' in other.parents:
        continue
    tree = ET.parse(str(other))
    assert not set(ids) & set(tree.xpath('//Asset/Values/Standard/GUID/text()')), other

# Project the three basic ModOps with lxml to assert intended node counts. This is
# deliberately not labeled a loader evaluation (no engine merge implementation).
before = [ET.tostring(n) for n in asset[0].xpath('Values/ShortcutConfig/InputBindings/Item')]
container = asset[0].find('Values/ShortcutConfig/InputBindings')
quit_node = container.xpath("Item[InputTypes/Modern/KeyType='Alt;F4']")[0]
ET.SubElement(quit_node, 'Command').text = 'Game:FastQuit(1)'
for node in patch.xpath("/ModOps/ModOp[@Type='add']/Item"):
    container.append(copy.deepcopy(node))
after = list(container)
assert len(after) == len(before) + 7 == 143
for index, original in enumerate(before):
    if after[index] is not quit_node:
        assert ET.tostring(after[index]) == original
assert quit_node.findtext('Command') == 'Game:FastQuit(1)'

bindings = patch.xpath("/ModOps/ModOp[@Type='add']/Item")
assert len(bindings) == 7
expected = {'Alt;C', 'Alt;B', 'Alt;V', 'Alt;G', 'Alt;Delete', 'Shift;Delete', 'F11'}
for preset in ('Modern', 'Legacy'):
    keys = [n.findtext(f'InputTypes/{preset}/KeyType') for n in bindings]
    assert set(keys) == expected and len(keys) == len(set(keys))
    assert not expected & set(ET.fromstring(ET.tostring(container)).xpath(f'Item[position() <= 136]/InputTypes/{preset}/KeyType/text()'))
assert len({n.findtext('Command') for n in bindings}) == len(bindings)
menu_commands = {
    'CheatKeybindsSerpPrevious': 'CheatKeybinds_Serp.ChangeCheat(-1)',
    'CheatKeybindsSerpNext': 'CheatKeybinds_Serp.ChangeCheat(1)',
    'CheatKeybindsSerpExecute': 'CheatKeybinds_Serp.StartCheat()',
    'CheatKeybindsSerpExecuteAlternative': 'CheatKeybinds_Serp.StartCheat(true)',
}
for identifier, command in menu_commands.items():
    matches = [n for n in bindings if n.findtext('Identifier') == identifier]
    assert len(matches) == 1 and matches[0].findtext('Command') == command
alternative_binding = next(n for n in bindings if n.findtext('Identifier') == 'CheatKeybindsSerpExecuteAlternative')
assert alternative_binding.findtext('Text') == '1500001258'
assert alternative_binding.findtext('Configurable') == '1'
assert not patch.xpath("//Template[text()='ActionExecuteScript']")
assert len(patch.xpath('//TriggerSetup[AutoRegisterTrigger="0" and UsedBySecondParties="0"]')) == 32
assert len(patch.xpath('//Asset/Values/Trigger/TriggerCondition[Template="ConditionAlwaysTrue"]')) == 32
assert len(patch.xpath('//SideNotification/IsSilent[text()="0"]')) == 30
assert not patch.xpath('//SideNotification/IsSilent[text()!="0"]')
assert len(patch.xpath('//SideNotification/IconAsset[text()="500271"]')) == 30
assert len(patch.xpath('//BaseNotification/NotificationPriority[text()="-1"]')) == 30
assert len(patch.xpath('//BaseNotification/IsUnique[text()="1"]')) == 30
assert len(patch.xpath('//IsUnique')) == 30
global_config = native.xpath('//Asset[Values/Standard/GUID="25000040"]')
assert len(global_config) == 1 and global_config[0].findtext('Template') == 'NotificationConfiguration'
assert global_config[0].find('BaseAssetGUID') is None
native_side = global_config[0].find('Values/NotificationConfiguration/NotificationTypeArray/Side')
assert native_side is not None and native_side.find('Delay') is None
templates = ET.parse(str(vanilla / 'data/base/config/export/templates.xml'))
assert templates.xpath('//Template[Name="NotificationConfiguration"]/Properties/NotificationConfiguration/NotificationTypeArray/Side/Delay/text()') == ['1000']
# Removed diagnostic IDs must not appear in any live package XML or Lua.
assert not patch.xpath('//Asset[Values/Standard/GUID="1500001294" or Values/Standard/GUID="1500001295"]')
assert not patch.xpath('//NotificationAsset')
delay_ops = patch.xpath('/ModOps/ModOp[@GUID="25000040"]')
assert len(delay_ops) == 1
delay_op = delay_ops[0]
assert delay_op.get('Type') == 'merge'
assert delay_op.get('Path') == '/Values/NotificationConfiguration/NotificationTypeArray/Side'
assert [n.tag for n in delay_op] == ['Delay'] and delay_op.findtext('Delay') == '0'
# Structural projection: only add the inherited Delay override; preserve every other field.
projected_side = copy.deepcopy(native_side)
ET.SubElement(projected_side, 'Delay').text = '0'
projected_side.remove(projected_side.find('Delay'))
assert ET.tostring(projected_side) == ET.tostring(native_side)
for guid, delta in ((1500001256, 10), (1500001257, -10)):
    matches = patch.xpath('//Asset[Values/Standard/GUID=$id]', id=str(guid))
    assert len(matches) == 1
    action = matches[0].find('.//TriggerAction/Values/ActionChangeReputation')
    assert action is not None
    assert action.findtext('UseProcessingParticipant') == '1'
    assert action.findtext('Amount/Value') == str(delta)
    assert action.findtext('AmountIsADelta') == '1'
    assert action.findtext('EmperorTrait') == '[NONE]'
    assert not matches[0].xpath('.//SideNotification | .//Participant')
for guid, lineid in ((1500001252, 1500001254), (1500001253, 1500001255)):
    assert patch.xpath('//Asset[Values/Standard/GUID=$id]//NotificationText/text()', id=str(guid)) == [str(lineid)]
for offset in range(14):
    assert patch.xpath('//Asset[Values/Standard/GUID=$id]//NotificationText/text()', id=str(1500001260+offset)) == [str(1500001280+offset)]

tool_icon = native.xpath('//Asset[Values/Standard/GUID="500271"]')
assert len(tool_icon) == 1 and tool_icon[0].findtext('Template') == 'Icon'
assert tool_icon[0].findtext('Values/Standard/IconFilename') == 'data/ui/fhd/base/icon_content/construction_tools/icon_2d_tools.png'

# Exercise all optional-mod combinations against their actual installed shortcut
# definitions (Gamespeed uses its maintained workspace package). Only the console
# label is patched here; no keys, commands or identifiers may change.
compatibility = {
    'console-ubi': console_mod,
}
package_inputs = {**compatibility, 'change-multiplayer-gamespeed-serp': root / 'Recommended/[Gameplay] GameSpeedMultiplayer'}
groups = patch.xpath('/ModOps/Group')
assert {g.get('Condition') for g in groups} == {'#' + name for name in compatibility}
assert sum(len(g) for g in groups) == 1
def identity(node):
    return (node.findtext('Command'), node.findtext('Identifier'),
            tuple(node.xpath('InputTypes/*/KeyType/text()')))
for switches in product((False, True), repeat=2):
    enabled = {name for name, active in zip(package_inputs, switches) if active}
    simulated = copy.deepcopy(asset[0])
    target = simulated.find('Values/ShortcutConfig/InputBindings')
    for name in enabled:
        other = ET.parse(str(package_inputs[name] / 'data/base/config/export/assets.xml'))
        additions = other.xpath('/ModOps/ModOp/Item')
        assert len(additions) == (1 if name == 'console-ubi' else 3)
        for node in additions:
            target.append(copy.deepcopy(node))
    identities = [identity(node) for node in target]
    count = len(target)
    for group in groups:
        if group.get('Condition')[1:] not in enabled:
            continue
        for operation in group:
            assert operation.get('Type') == 'merge' and operation.get('GUID') == '2001271'
            assert [child.tag for child in operation] == ['Text']
            matches = simulated.xpath('.' + operation.get('Path'))
            assert len(matches) == 1, (enabled, operation.get('Path'), len(matches))
            label = matches[0].find('Text')
            if label is None:
                label = ET.SubElement(matches[0], 'Text')
            label.text = operation.findtext('Text')
    assert len(target) == count
    assert [identity(node) for node in target] == identities

speed = root / 'Recommended/[Gameplay] GameSpeedMultiplayer'
speed_info = json.loads((speed / 'modinfo.json').read_text(encoding='utf-8-sig'))
assert speed_info['Version'] == '1.0.4' and speed_info['ModID'] == 'change-multiplayer-gamespeed-serp'
speed_patch = ET.parse(str(speed / 'data/base/config/export/assets.xml'))
speed_items = speed_patch.xpath('/ModOps/ModOp/Item')
assert len(speed_items) == 3
assert [n.findtext('Text') for n in speed_items] == ['1500000060', '1500000061', '1500000062']
assert [n.findtext('Command') for n in speed_items] == [f'Conditions:RegisterTriggerForCurrentParticipantNet({n})' for n in range(1500000050, 1500000053)]
assert [n.findtext('InputTypes/Modern/KeyType') for n in speed_items] == ['NumpadSubtract', 'NumpadAdd', 'Alt;NumpadAdd']
for language in (mod / 'data/base/config/gui').glob('texts_*.xml'):
    speed_text = ET.parse(str(speed / 'data/base/config/gui' / language.name))
    assert speed_text.xpath('//LineId/text()') == ['1500000060', '1500000061', '1500000062']
    expected = ['Spielgeschwindigkeit: Normal', 'Spielgeschwindigkeit: Schnell', 'Spielgeschwindigkeit: Sehr schnell'] if language.stem == 'texts_german' else ['Game speed: Normal', 'Game speed: Fast', 'Game speed: Very fast']
    assert speed_text.xpath('//Text[LineId]/Text/text()') == expected
assert 'change-multiplayer-gamespeed-serp' not in (mod / 'modinfo.json').read_text(encoding='utf-8-sig')
assert not patch.xpath('/ModOps/Group[@Condition="#change-multiplayer-gamespeed-serp"]')

metadata = ET.parse(str(vanilla / 'data/base/config/export/properties-meta.xml'))
for values in patch.xpath('//Asset/Values | //TriggerCondition/Values | //TriggerAction/Values | //Notification/Values'):
    for prop in values:
        allowed = metadata.xpath('//Property[Name=$name]/ValueDefinition/Name/text()', name=prop.tag)
        if prop.tag == 'Standard': continue
        assert all(child.tag in allowed for child in prop), (prop.tag, [c.tag for c in prop], allowed)
info = json.loads((mod / 'modinfo.json').read_text(encoding='utf-8-sig'))
assert info['Version'] == '1.15.0' and info['ModID'] == 'cheat-keybinds-serp' and info['Anno'] == 8
assert set(compatibility) <= set(info['Dependencies']['Optional'])
assert set(compatibility) <= set(info['Dependencies']['LoadAfter'])
assert list(info['changelog']) == ['1.01', '1.011', '1.012', '1.013', '1.15.0']
assert not any(word in info['changelog']['1.15.0'].lower() for word in ('guid', 'mock', 'luau', 'infotip'))
assert info['Scripts']['Init'] == 'CheatKeybinds_Serp = require("cheatkeybinds_serp")'
assert (mod / info['Scripts']['Modules'][0]).is_file()
referenced_text = set(patch.xpath('//NotificationText/text() | //NotificationSideTitle/text() | /ModOps/ModOp/Item/Text/text() | //ModOp/Text/text()'))
langs = [p for p in (vanilla / 'data/base/config/gui').glob('texts_*.xml') if p.stem != 'texts_metadata']
for lang in langs:
    texts = ET.parse(str(mod / 'data/base/config/gui' / lang.name))
    lineids = texts.xpath('//Text/LineId/text()')
    assert len(lineids) == len(set(lineids)) == 39
    assert referenced_text <= set(lineids)
    assert not set(lineids) & set(ET.parse(str(lang)).xpath('//Text/LineId/text()'))
    for lineid in [*range(1500001221, 1500001233), 1500001254, 1500001255]:
        description = texts.xpath('//Text[LineId=$id]/Text/text()', id=str(lineid))[0]
        assert not re.search(r'\[\d+/\d+\]', description)
        assert 'Alt+' not in description
for path in mod.rglob('*'):
    if path.is_file() and path.suffix in ('.xml', '.lua'):
        assert not re.search(r'150000129[456]|ExecutionNotificationGUIDs', path.read_text(encoding='utf-8-sig')), path
for path in [*mod.rglob('*'), *speed.rglob('*')]:
    if path.suffix in ('.xml', '.lua', '.json'):
        raw = path.read_bytes()
        raw.decode('utf-8-sig')
        assert b'\n' not in raw.replace(b'\r\n', b''), f'Non-CRLF: {path}'

source = (mod / 'data/cheatkeybinds_serp.lua').read_text(encoding='utf-8-sig')
harness = r'''
local calls, notices, logs = {}, {}, {}
local function record(name)
  return function(self, ...)
    table.insert(calls, {name, ...})
  end
end
print = function(...) table.insert(logs, {...}) end
local function register(self, guid)
  if guid == 1500001256 or guid == 1500001257 then
    table.insert(calls, {"reputation", guid})
  else
    table.insert(notices, guid)
  end
end
Conditions = { RegisterTriggerForCurrentParticipantNet = register }
local function valid() return true end
local function invalid() return false end
local area = { isValid = valid, IsOwnedByCurrentParticipant = true, Economy = { AddAmount = record("goods") }, Takeover = record("takeover") }
local object = { isValid = valid, IsOwnedByCurrentParticipant = true, IsKontor = false, Area = area, Villa = { isValid = invalid } }
for _, name in {"Factory", "Recruitment", "Monument"} do
  object[name] = { isValid = valid }
end
object.Factory.ToggleCheatFertility = record("fertility")
object.Recruitment.CheatSkipRemainingTime = record("recruitment")
object.Monument.CheatUpgradeMicro = record("monument")
Selection = { Object = object, ChangeParticipantOfSelected = record("owner") }
Area = { Current = area, CurrentSelectedArea = area, IsCurrentAreaValidIsland = true }
Economy = { MetaStorage = { AddAmount = record("money") } }
AreaWorkforce = { isValid = valid, CheatChangeWorkforce = record("workforce") }
Cheat = { GlobalCheats = { ToggleIgnoreBuildingCosts = record("costs"), ToggleUpgradeCheck = record("upgrades") } }
local queued = { Guid = 123 }
TechHandler = {
  GetTechAtQueuePosition = function(self, pos) assert(pos == 0); return queued end,
  CompleteTechResearch = record("research"), StopTech = record("stopResearch"),
  CheatResearchAll = record("allResearch"), CheatResetAll = record("resetAllResearch"),
}
Item = { CheatAllItems = record("items") }
local diplomacy = { isValid = valid, ResetAllActionCooldownsNet = record("cooldowns") }
local participant = { isValid = valid, Diplomacy = diplomacy }
local emperor = { isValid = valid }
Participants = { GetCurrentParticipantGUID = 42, Current = participant, ActiveEmperorProperty = emperor }
datasets = { TakeOverTransformation = { ChangeOwner = 0 } }
local module = (function()
-- MODULE_SOURCE
end)()
local checks = 0
local function check(value) assert(value, "check " .. (checks + 1)); checks += 1 end
local expected_notices = {1500001201,1500001202,1500001203,1500001204,1500001205,1500001206,1500001207,1500001208,1500001209,1500001210,1500001211,1500001212,1500001252,1500001253}
check(#module.Cheats == 14 and #module.NotificationGUIDs == 14)
for i, guid in expected_notices do
  check(module.NotificationGUIDs[i] == guid and guid ~= 1500001213 and guid ~= 1500001214)
end
local function execute(index, alternative)
  table.clear(calls); table.clear(notices)
  module.ActiveCheat = index; module.StartCheat(alternative)
end
module.ChangeCheat(1); module.StartCheat(); module.StartCheat(true); check(#calls == 0 and #notices == 0)
module.GameLoaded(); check(module.ActiveCheat == 1)
module.ChangeCheat(-1); check(module.ActiveCheat == 14 and notices[#notices] == 1500001253 and #calls == 0)
module.ChangeCheat(1); check(module.ActiveCheat == 1 and #calls == 0)
module.ChangeCheat(29); check(module.ActiveCheat == 2 and #calls == 0)
local normal = {"money","goods","workforce","costs","upgrades","fertility","recruitment","monument","research","allResearch","items","owner","reputation","cooldowns"}
local alternate = {"money","goods","workforce","costs","upgrades","fertility","recruitment","monument","stopResearch","resetAllResearch","items","owner","reputation","cooldowns"}
for _, alternative in {false, true} do
  local expected = alternative and alternate or normal
  for i, name in expected do
    object.IsOwnedByCurrentParticipant = i ~= 12
    execute(i, alternative)
    check(#calls == 1 and calls[1][1] == name)
    check(#notices == 1 and notices[1] == expected_notices[i])
  end
  execute(1, alternative); check(calls[1][2] == 1010017 and calls[1][3] == (alternative and -100000 or 100000))
  execute(2, alternative); check(calls[1][2] == (alternative and -1000 or 1000))
  execute(3, alternative); check(calls[1][2] == (not alternative))
  execute(9, alternative); check(calls[1][2] == 123)
  if not alternative then check(calls[1][3] == true) end
  execute(13, alternative); check(calls[1][2] == (alternative and 1500001257 or 1500001256))
end
execute(1, "true"); check(calls[1][3] == 100000) -- only Boolean true selects the alternative
local failures = {
  goods_area=1500001260, workforce_area=1500001261, items_area=1500001262,
  selection_missing=1500001263, factory_selection=1500001264,
  recruitment_selection=1500001265, monument_selection=1500001266,
  foreign_selection=1500001267, research_empty=1500001268,
  takeover_owned=1500001269, participant_missing=1500001270,
  emperor_missing=1500001271, diplomacy_missing=1500001272,
  workforce_unavailable=1500001273,
}
for reason, guid in failures do check(module.FailureNotificationGUIDs[reason] == guid) end
local function fails(index, reason)
  for _, alternative in {false,true} do
    execute(index,alternative)
    check(#calls == 0 and #notices == 1 and notices[1] == failures[reason])
    local line = tostring(logs[#logs][1])
    check(string.find(line,tostring(index),1,true) ~= nil and string.find(line,reason,1,true) ~= nil)
    check(string.find(line,alternative and "alternative" or "normal",1,true) ~= nil)
  end
end
for _, missing in {"zero","nil","field"} do
  if missing == "zero" then queued={Guid=0} elseif missing == "nil" then queued=nil else queued={} end
  fails(9,"research_empty")
end
queued={Guid=123}
object.IsOwnedByCurrentParticipant=true
fails(12,"takeover_owned")
object.IsOwnedByCurrentParticipant=false; object.IsKontor=true
for _, alternative in {false,true} do
  execute(12,alternative);check(#calls==1 and calls[1][1]=="takeover" and calls[1][2]==42 and calls[1][3]==0)
end
object.IsKontor=false;object.Villa.isValid=valid
execute(12);check(calls[1][1]=="takeover")
object.isValid=invalid
for _, index in {6,7,8,12} do fails(index,"selection_missing") end
object.isValid=valid;object.IsOwnedByCurrentParticipant=true
for property, index in {Factory=6,Recruitment=7,Monument=8} do
  object[property].isValid=invalid
  fails(index,string.lower(property).."_selection")
  object[property].isValid=valid
end
object.IsOwnedByCurrentParticipant=false
for _,index in {6,7,8} do fails(index,"foreign_selection") end
object.IsOwnedByCurrentParticipant=true
Area.IsCurrentAreaValidIsland=false
for _,alternative in {false,true} do execute(2,alternative);check(#calls==1 and calls[1][1]=="goods") end
fails(3,"workforce_area");fails(11,"items_area")
area.IsOwnedByCurrentParticipant=false
fails(2,"goods_area")
Area.IsCurrentAreaValidIsland=true
fails(2,"goods_area");fails(3,"workforce_area");fails(11,"items_area")
area.IsOwnedByCurrentParticipant=true
AreaWorkforce.isValid=invalid;fails(3,"workforce_unavailable");AreaWorkforce.isValid=valid
local workforce=AreaWorkforce;AreaWorkforce=nil;fails(3,"workforce_unavailable");AreaWorkforce=workforce
participant.isValid=invalid
fails(13,"participant_missing");fails(14,"participant_missing")
participant.isValid=valid
emperor.isValid=invalid;fails(13,"emperor_missing");emperor.isValid=valid
diplomacy.isValid=invalid;fails(14,"diplomacy_missing");diplomacy.isValid=valid
Participants.Current=nil;fails(13,"participant_missing");fails(14,"participant_missing");Participants.Current=participant
Participants.ActiveEmperorProperty=nil;fails(13,"emperor_missing");Participants.ActiveEmperorProperty=emperor
participant.Diplomacy=nil;fails(14,"diplomacy_missing");participant.Diplomacy=diplomacy
local saved=module.Cheats[1]
for _, reason in {"unknown_reason",false} do
  module.Cheats[1]=function() return false,reason end
  for _,alternative in {false,true} do execute(1,alternative);check(#calls==0 and notices[1]==1500001213) end
end
module.Cheats[1]=function() return false end
for _,alternative in {false,true} do execute(1,alternative);check(#calls==0 and notices[1]==1500001213) end
module.Cheats[1]=saved
Conditions.RegisterTriggerForCurrentParticipantNet = function(self,guid)
  if guid == 1500001256 or guid == 1500001257 then error("reputation action unavailable") end
  register(self,guid)
end
for _, alternative in {false,true} do execute(13,alternative); check(#calls == 0 and notices[1] == 1500001214) end
Conditions.RegisterTriggerForCurrentParticipantNet = register
Economy.MetaStorage.AddAmount = function() error("unavailable binding") end
for _, alternative in {false,true} do
  execute(1,alternative);check(#calls==0 and notices[1]==1500001214)
  local line=tostring(logs[#logs][1])
  check(string.find(line,"unavailable binding",1,true)~=nil)
  check(string.find(line,alternative and "alternative" or "normal",1,true)~=nil)
  check(string.find(line,"1",1,true)~=nil)
end
Conditions.RegisterTriggerForCurrentParticipantNet = function() error("notification unavailable") end
module.ChangeCheat(1); check(module.ActiveCheat == 2) -- display failure does not prevent selecting
module.GameUnloaded(); check(module.ActiveCheat == 1 and not module.Loaded)
table.clear(calls); module.StartCheat(); module.StartCheat(true); module.ChangeCheat(1); check(#calls == 0 and module.ActiveCheat == 1)
module.GameLoaded(); check(module.ActiveCheat == 1 and module.Loaded)
return checks
'''
generated = harness.replace('-- MODULE_SOURCE', source)
# Restore a visible terminal result without changing module print behavior.
generated = 'local output = print\nlocal checks = (function()\n' + generated + '\nend)()\noutput("PASS: " .. checks .. " Luau mock checks (not game execution)")\n'
out = root / 'Documentation/out/cheat-keybinds-mock.luau'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_bytes(generated.replace('\n','\r\n').encode('utf-8'))
assert len(patch.xpath('//SideNotification/Infotip[text()="0"]')) == 30
assert not patch.xpath('//SideNotification/Infotip[text()!="0"]')

print(f'PASS: XML/metadata/localization/CRLF checks; {len(langs)} languages, 32 triggers (30 notices + 2 reputation actions), 7 shortcuts, 4 optional-mod combinations.')
print(f'Generated Luau mock test: {out}')
