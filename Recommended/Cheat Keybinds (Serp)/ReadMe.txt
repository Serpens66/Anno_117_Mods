Anno 117 - Cheat Keybinds (Serp) - Version 1.15.0

1.15.0 changes:
- Reworked controls: select the previous/next cheat, then execute it normally or
  alternatively. All four controls can be rebound in the game settings.
- New cheats: increase/decrease emperor reputation and reset diplomacy cooldowns.
- Replaced the old population cheat with workforce increase/decrease.
- Alternative actions: subtract coins or goods, cancel current research,
  and reset all research.

Bedienung wie im Anno-1800-Mod / Controls as in the Anno 1800 mod:
- Alt+C: vorherigen Cheat auswählen / select previous cheat (-1)
- Alt+B: nächsten Cheat auswählen / select next cheat (+1)
- Alt+V: ausgewählten Cheat normal ausführen / execute selected cheat normally
- Alt+G: ausgewählten Cheat alternativ ausführen / alternative execution
Beim Auswählen zeigt die Meldung zuerst die Wirkung, danach kurze Details.
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
Alt+F4 is a separate native quit shortcut.

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
- ModID and mod.io resource ID are retained. Version 1.15.0 follows legacy 1.013.

Important usage notes:
- Ignoring building costs can still spend money and cause bankruptcy.
- Workforce changes do not fill residences or add resident population.
- Cancelling current research does not promise a refund.
- Coin/goods subtraction is available, but its behavior at low balances has not
  been confirmed in game. Keep a separate save before using it.
- This mod also reduces the initial display delay of ordinary game side notices.
- Existing saved key assignments are preserved; change them in Controls if needed.

Implementation and source details: Documentation/reference/cheat-keybinds-audit.md

--------------------------------------------------------------------------
Historical 1.013 readme follows. Its direct cheat keys are inactive in 1.15.0.
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
