# Serp mod runtime examples

This chapter records package implementations, tests and user observations for Serp's mods. Apply each finding within its stated package version and test context. The general host APIs and Vanilla Lua source map are maintained separately. [General Luau and runtime](../foundations/luau-and-runtime.md)

The following sections preserve the development snapshots named in their headings and audit links. For the consolidated current package and checker inputs, use the maintained cleanup audit and tool instructions. [Current Cheat Keybinds audit](cheat-keybinds-audit.md#consolidated-1150-release-cleanup-2026-11-12) · [Current checker inputs](../tools/README.md#serp-mod-cheat-keybinds-offline-checks)

`WIP/ztestmod` demonstrates hooks and exploratory code and remains an unverified harness.

## Source provenance

For the 2026-11-12 Cheat Keybinds audit, the relevant generated bindings and globals were hash-checked against the manifest, and all 40 installed archive inventory entries matched. This supplements the 3.0 baseline and covers the sources used by that feature audit.

## Bounded Vanilla cross-check: GameSpeedMultiplayer

- **Vanilla 3.0:** the `ActionExecuteScript` template exists; `properties-meta.xml:6104` gives a `FileName` field named `ScriptFileName`. Asset examples at `assets.xml:511107` and `:605636` reference existing campaign Lua scripts. The generated `CGameClock.SetGameSpeed` declaration and `datasets.xml:22432` show IDs 0 Paused, 1 HalfSpeed, 2 Normal, 3 Fast and 4 Fastest. The dataset alone does not prove which states are allowed in multiplayer.
- **Workspace 1.0.3:** `Recommended/[Gameplay] GameSpeedMultiplayer` registers participant triggers from keybind commands, disables auto-registration for its trigger definitions, and dispatches one of three mod scripts through `ActionExecuteScript`. The scripts set speed 2/3/4 and invoke a separate notification trigger. The author records local-only shortcut execution and peer execution through the action. This is a scoped author report for this mod, not a general rule for all XML actions or all game versions.
- **Pending:** no 3.0 runtime check of peer scope, repeated trigger registration, speed transitions, late join, save/load or notification duplication. The WIP version documents a separate unresolved participant variable and notification path. Re-audit before choosing or extending either design.

Test locally with a disposable save, then check distinct participants and co-op peers, their active sessions, reconnect and removal when applicable. Record the initiating peer and exactly what every other peer sees. Metadata multiplayer flags, no crash on launch, and shared code on disk are separate from synchronization evidence.

## Module entrypoint observation

The 2026-11-12 main game log confirms mod-global calls from ShortcutConfig reaching Cheat Keybinds 1.14.0 on the tested installation. The observation does not identify which patch fixed the older failure or establish every execution context. [Runtime continuation](cheat-keybinds-audit.md#1141-label-and-notification-audit-2026-11-12)

## Cheat Keybinds and shortcut dispatch

The [feature audit](cheat-keybinds-audit.md) records exact targets, inheritance/defaults, source provenance, binding owners, 1800 differences, notification consumers and runtime gaps. Cheat Keybinds calls its initialized module from the native ShortcutConfig input binding.

Use explicit function values for cheat dispatch. Do not depend on loadstring, 1800 ts wrappers, old coroutine helpers or availability of the optional Cheats debug global. `Cheats` is declared in Vanilla but was reported nil by the older workspace and is confirmed empty by the user in the current tested runtime (2026-11-12). Do not recommend `Cheats:ShowNotification` based on its signature alone. The manual Vanilla-notification diagnostic in 1.15.6 uses participant trigger 1500001294 and native ActionNotification/NotificationAsset instead. [Audit](cheat-keybinds-audit.md#1156-vanilla-notification-diagnostic-without-cheats-2026-11-12) The selection UI uses fixed localized LineIDs and notification-only participant triggers instead of changing a neutral participant's profile name. Gameplay stays in the initiating shortcut's module call; this avoids an additional ActionExecuteScript execution path but does not establish multiplayer safety.

117 equivalents include Recruitment:CheatSkipRemainingTime() and TechHandler:GetTechAtQueuePosition(0) plus CompleteTechResearch(). The older AreaPopulation:CheatChangePopulation(true) declaration did not establish fill-all-residences behavior, and the user now reports no advertised effect; 1.15.0 replaces it with direct AreaWorkforce:CheatChangeWorkforce(true/false), with no claimed amount. Guard invalid objects/properties, zero tech GUIDs and island ownership. A function with implicit current-area context cannot be redirected by merely obtaining Area.CurrentSelectedArea; selected-area fallback is appropriate only when the action is explicitly called on that area's Economy.

Run `Documentation/tools/check_cheat_keybinds.py` for structural checks and generation of a standalone Luau mock harness under ignored `Documentation/out`. Execute the harness with Luau via the workspace permission route. This checks module state and dispatch, not native binding availability, shortcut entrypoints, notifications, saves or peer synchronization. See the audit for the remaining in-game test matrix.

In the 1.14.1 snapshot, the checker read the installed optional console/speed shortcut definitions through `modsPath` and projected all four presence/absence combinations. Current checker inputs are documented in the tool instructions linked above. Compatibility patches change labels only and run after the respective optional mod. Preserve Commands, Identifiers and key defaults when relabeling; the user's tested menu-key override persisted across a restart. `IsSilent` has no documented runtime semantics in the generated metadata: do not assume it means only muted audio. The user now confirms visible selection notices with 1.14.1 and IsSilent=0, with a screenshot. Keep this scoped to the tested configuration. 1.14.2 retains 0 and uses compact action-first text plus tools icon 500271; wrapping, expansion and the icon still need an in-game visual check. [Continuation](cheat-keybinds-audit.md#1142-compact-notifications-and-tools-icon-2026-11-12)


### Directed cheats and priority (1.15.0)

The [1.15.0 audit](cheat-keybinds-audit.md#1150-immediate-selection-and-alternative-execution-2026-11-12) records normal/alternative calls, signed-amount candidates, explicit research actions, emperor processing-participant actions and the direct workforce/cooldown owners. Use one optional Boolean argument rather than polling key state: the extra configurable Alt+Shift+V binding passes true; the normal existing shortcut stays unchanged. Three-key bindings already occur natively. Keep an explicit notification-GUID mapping when extending the menu because old indices 13/14 would otherwise select the error notices.

Priority -1 is present in native 117 SideNotification examples and the 1800 selection notice. It replaces 200 on all mod notices without adding timers or deleting normal game notifications; actual latest-selection replacement remains a game test. IsSilent=0 remains based on the user's visible 1.14.1 result. Do not infer engine-side timing, native negative-amount effects, workforce quantity or multiplayer synchronization from empty binding declarations or mocked calls.

The user reports a 40-character console input limit and nonworking paste in the current tested configuration. Version 1.15.7 therefore exposes the native notification diagnostic through existing shortcuts as menu entry 15. Selection and execution have distinct notification-GUID mappings, so executing the diagnostic does not immediately redisplay its custom label over the Vanilla notice. No new keybind is added. [Audit](cheat-keybinds-audit.md#1157-diagnostic-through-existing-keybinds-2026-11-12)

Current package after user-requested cleanup: development snapshots1.14.x/1.15.1-1.15.7 are consolidated into1.15.0. The diagnostic trigger/menu entry and ExecutionNotificationGUIDs override described above are historical and removed. The normal14-entry cycle uses its original notification mapping; test IDs1294-1296 remain reserved. The Cheats-table and hover observations remain valid scoped evidence. [Current audit](cheat-keybinds-audit.md#consolidated-1150-release-cleanup-2026-11-12)
