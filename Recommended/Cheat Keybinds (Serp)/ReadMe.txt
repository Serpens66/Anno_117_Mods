Anno 117 - Cheat Keybinds (Serp) - Version 1.15.3

1.15.3: Alternative execution defaults to Alt+G (normal execution remains Alt+V).
The Command and Identifier are preserved. Existing saved overrides may retain the
previous assignment; choose Alt+G in Controls if needed. No account/profile is edited.
Missing prerequisites now show a short reason: missing or foreign selection,
wrong factory/recruitment/monument type, owned takeover target, missing owned island,
empty research queue, missing participant/emperor/diplomacy/workforce manager.
Unexpected Lua failures retain a short notice and log the full error, cheat and direction.
Priority -1, global Side/Delay=0 and IsUnique=1 remain unchanged.
No favorites, groups, direct-cheat hotkeys or console-command system is added.

1.15.2: Global Side notification Delay=0, previously inherited as 1000.
This affects ALL side notices, including normal game notifications. Display durations
and queue timeouts are unchanged. Our 16 cheat notices also use IsUnique=1.
Test whether a visible identical notice is suppressed while the cheat still executes;
after it disappears it must be possible to display it again. Also test A -> B -> A,
pause/menus and ordinary notifications. Neither latency reduction nor uniqueness
lifetime is confirmed by an in-game test yet. Lua and shortcut definitions are unchanged.

1.15.1 (historical): Alternative execution default changed to Alt+Space+V. Recognition of Space+V
as a chord requires an in-game test. Existing saved overrides are not overwritten;
rebind the alternative shortcut in Controls if it retains the previous assignment.
No per-notice initial display-delay field was found or changed.

1.15.0 changes / Änderungen:
- Alt+V führt die normale Richtung aus; Alt+Shift+V die alternative Richtung.
  Beide sind in den Tastatureinstellungen umbelegbar und nutzen dieselbe Cheat-Auswahl.
- Neue Einträge: Kaiserruf ±10 und eigene Diplomatie-Cooldowns zurücksetzen.
- Der wirkungslose Bevölkerungscheat ist durch Arbeitskräfte erhöhen/senken ersetzt.
  Verwendet den direkten nativen Aufruf; keine fest behauptete Menge und kein Hausfüllen.
- Normal Alt+V / alternative Alt+Shift+V share one selected cheat. Existing bindings remain.
- Selection/error notices now use priority -1, matching the old Anno 1800 selection
  notice and native 117 examples. Immediate replacement still needs an in-game test.
- Tools icon, IsSilent=0 and zero blocking times are retained. No queue timer or
  deletion of ordinary game notifications is added.

Normal / alternative execution:
- Coins: +100,000 / -100,000.
- All goods: native AddAmount(+1000) / AddAmount(-1000) on the same owned island.
- Workforce: AreaWorkforce:CheatChangeWorkforce(true) / (false) on your current owned island.
- Current research: complete / stop the first queued technology. No refund is promised.
- All research: research all / reset all, rather than automatically toggling on repeat.
- Emperor reputation: +10 / -10 for the current participant and active emperor.
- All remaining cheats use the same action in both directions. Cost/upgrade/fertility
  cheats already toggle themselves; no invented undo for recruitment, monuments,
  random items or ownership is provided. Cooldown reset also uses the same action.

New effects are not yet verified in game. In particular, negative money/goods amounts
are candidates supported by the integer parameter declaration, without a found native
negative Lua example. Test actual deductions and small balances/stocks. The amount
changed by the direct workforce cheat is unspecified. Diplomatic cooldown reset uses
only your participant's Diplomacy property; verify negotiations with at least two AIs.
Other block reasons, such as pending answers or missing requirements, are separate.

1.14.2 changes / Änderungen:
- Meldungen beginnen direkt mit Wirkung, Menge oder Umschaltfunktion. Keine [2/12]-Zähler
  oder wiederholten Standardtasten-Hinweise; kurze Einschränkungen folgen im vollen Text.
- Werkzeug-Icon statt Sanduhr bei allen Auswahl- und Fehlermeldungen.
- Action-first notices without counters/default-key hints; concise context follows.
  All 14 notices use the native tools icon. Commands, IDs and key assignments are unchanged.
- The user confirmed visible selection notices in 1.14.1 with IsSilent=0, including
  a screenshot. IsSilent=0 is retained. Check the new wrapping/tools icon after restarting.

1.14.1 changes / Änderungen:
- Eindeutige Beschriftungen für Löschen, Zerstören und Mods-Neuladen.
- Korrekte Beschriftungen für die optionale Lua-Konsole und die drei Geschwindigkeitsstufen.
- Distinct delete/destroy/reload labels; label-only compatibility patches for console-ubi
  and change-multiplayer-gamespeed-serp. Neither optional mod is required or modified.
- All 14 selection/error notices switched to IsSilent=0. The subsequent user report
  and screenshot confirmed visible selection notices in the tested 1.14.1 configuration.
- Commands, identifiers and default keys are unchanged. Your saved Alt+X override
  is not edited. The user confirmed a menu-key override survives a restart in 1.14.0.

Bedienung wie im Anno-1800-Mod / Controls as in the Anno 1800 mod:
- Alt+C: vorherigen Cheat auswählen / select previous cheat (-1)
- Alt+B: nächsten Cheat auswählen / select next cheat (+1)
- Alt+V: ausgewählten Cheat normal ausführen / execute selected cheat normally
- Alt+G: ausgewählten Cheat alternativ ausführen / alternative execution
Beim Auswählen zeigt die Meldung zuerst die Wirkung, danach kurze Details.
In 1.14.0 war sie beim Nutzer unsichtbar; mit 1.14.1 und IsSilent=0 ist die Anzeige bestätigt.
Cycling only selects; it never executes a cheat. Selection wraps around at both ends.
After loading a game, the first cheat (coins) is selected. Selection is not saved.

Cheat-Auswahl / Cheat selection:
 1. Münzen +100.000 / alternativ -100.000 / Coins +100,000 / alternative -100,000
 2. Alle Güter hinzufügen / abziehen / Add / deduct all unlocked goods
 3. Arbeitskräfte erhöhen / senken / Increase / decrease workforce
 4. Baukosten ignorieren Ein/Aus / Ignore building costs toggle
 5. Ausbauten erlauben Ein/Aus / Allow upgrades toggle
 6. Fruchtbarkeit der angewählten Fabrik / Selected factory fertility toggle
 7. Rekrutierung fertigstellen / Complete recruitment (ship or unit)
 8. Monument weiterbauen / Advance monument construction
 9. Aktuelle Forschung fertigstellen / abbrechen / Complete / stop current research
10. Alle Forschung freischalten / zurücksetzen / Research all / reset all research
11. Zufällige Items / Random items
12. Besitzer ändern / Change selected object's owner (Kontor/Villa: island takeover)
13. Kaiserruf +10 / alternativ -10 / Emperor reputation +10 / alternative -10
14. Eigene Diplomatie-Cooldowns zurücksetzen / Reset own diplomatic action cooldowns

Die bisherigen Einzel-Cheat-Tasten (Insert/Home/End und Control+Delete) sind ersetzt.
The old individual cheat shortcuts (Insert/Home/End and Control+Delete) are replaced.
Die vier Menütasten sind in den Spieleinstellungen als eigene Einträge verfügbar.
The four menu shortcuts have separate entries in the game's shortcut settings.
Both Modern and Legacy presets use the defaults above.

Separate shortcuts retained:
- Alt+Delete: remove selected object without a ruin, including foreign objects
- Shift+Delete: existing positional damage command at the selected object; can leave ruins
- Alt+F4: quit immediately without saving
- F11: existing mod reload command

Settings labels / Beschriftungen in den Tastatureinstellungen:
- Alt+Delete: Cheats: Auswahl löschen (ohne Ruine)
- Shift+Delete: Cheats: Auswahl zerstören
- F11: Mods neu laden
- Shift+F4 (console-ubi): Lua-Konsole öffnen/schließen
- Keypad - / Keypad + / Alt+Keypad + (GameSpeedMultiplayer): Normal / Schnell / Sehr schnell
These are distinct actions from multiple mods, not duplicate cheat-menu shortcuts.
The placeholder row on Shift+F4 came from the console shortcut without a Text field.
Alt+F4 is a separate native quit shortcut and its label is not changed in 1.14.1.

Context and compatibility:
- Goods use your current island, or the island of a selected building in a menu.
- Workforce and random items require your current owned island (hover over it).
- Workforce uses the native current-island context directly; no selected-island fallback.
- Emperor reputation requires a valid current participant and active emperor.
- Cooldown reset needs your valid Diplomacy property, not a selected AI object.
- Factory/recruitment/monument cheats require a suitable owned selected object.
- Current research requires a non-empty queue. Inapplicable actions show a notice.
- Alternative All Research resets research; normal execution always researches all.
- Ownership change can desync multiplayer.
- No Anno 1800-only cheats, ship buffs, voice lines or neutral-name workaround are ported.
- Do not enable this package together with WIP or demo copies sharing cheat-keybinds-serp.
- ModID and mod.io resource ID are retained. Semantic version 1.14.0 follows legacy 1.013.

Validation / Tests:
Sources audited against installed 3.0 Vanilla XML and Lua bindings on 2026-11-12.
Earlier 1.14.0 checks passed XML/metadata/localization, Luau compilation and 42 mocked checks.
A mock does not run the game. The 1.14.0 game log confirms calls from shortcuts into
the module and normal returns from several cheats. The user reports preserved key
rebinding after restart and apparently working cheats, initially without visible notices.
1.14.1 structural checks covered all four console/speed optional-mod combinations;
the user's subsequent screenshot confirms visible selection notices with IsSilent=0.
1.14.2 checks preserve the IDs/shortcuts/Lua and validate the new text/icon references.
1.15.0 passes XML/metadata/text/optional-mod checks, Luau 0.746 compilation and
136 isolated mock checks for both directions and invalid contexts. Native effects,
immediate notice replacement, small-stock deductions, research cancellation/refunds,
save/load/removal and multiplayer/coop remain separate game checks.
Existing multiplayer/removal metadata is retained; it is not a new compatibility claim.

Quick in-game test (use a disposable save and only one Cheat Keybinds variant;
the optional console/speed mods may remain enabled to check their corrected labels):
0. Restart normally with 1.15.0. Check the tools icon, compact/expanded text and that
   a saved override such as Alt+X remains assigned. Test notices unpaused, then repeatedly.
   Do not use Alt+F4 to test settings saving: this mod makes it quit immediately.
1. With default keys, after load press Alt+B: all-goods notice, no goods added yet.
   Alt+C returns to the add-coins notice. Use your assigned keys if you changed them.
2. Compare coins before/after Alt+V and Alt+G: each must issue only its one direction.
   Previous wraps to the cooldown entry; next returns to coins.
3. Try repeated/rapid cycling, while paused and with menus open. Check the displayed
   effect matches the action. If the mod global is nil, capture the game log before
   trying any gameplay workaround; this is the historically failing entrypoint.
4. Test all fourteen entries in both directions, missing/foreign selection, ocean and
   empty research queue. Measure workforce before/after both calls (no +500 assumption),
   and check goods deductions with small stocks. Test takeover/destruction only on the test save.
5. Test emperor reputation +10/-10, current research complete/stop and all research/reset.
   Do not assume cancelling research refunds its costs. Check diplomatic cooldowns
   against at least two AIs; distinguish other blocked-action reasons.
6. Cycle quickly: the latest notice should replace the previous one immediately and
   obsolete notices should not play later. Repeat paused, after a full menu loop and
   with an ordinary game notice present. Priority -1 is not yet a confirmed 117 fix.
7. Reload the save and return from the main menu: selection should reset to the first entry.
8. Multiplayer/coop requires a separate peer test with identical packages; check every
   peer and do not infer synchronization from the absence of a local Lua error.

Implementation and source details: Documentation/reference/cheat-keybinds-audit.md

--------------------------------------------------------------------------
Historical 1.013 readme follows. Its direct cheat keys are inactive in 1.14.0.
--------------------------------------------------------------------------

Anno 117
Helpful for testing: Cheat_Keybinds 

**Cheat Keybinds (Serp)** to easily test mods.

Adds some keybinds for cheats to easier test the mod:

- Shift+End -> Ship/Unit currently in selected shipyard production gets instantly completed
- Control+Insert -> Build costs are ignored (but you still can go bankrupt)
- Control+End -> finish a portion of selected monument building phase, hit multiple times to finish it
- Insert -> Adds 500 of all already unlocked population to the global population (helps to unlock stuff)
- Shift+Insert -> gives you 100k coins
- Alt+Insert -> gives you up to 1000 of every already unlocked good to the island you are currently hovering over
- Alt+End -> Research everything / undo research of everything
- Alt+Home -> Allows you to upgrade every building (also residences) regardless if conditions are fullfilled or not.
- Control+Home -> add the needed fertility from the currently selected factory to the island
- Home -> add random items to the current island
- Alt+F4 -> fast quit the game without saving
